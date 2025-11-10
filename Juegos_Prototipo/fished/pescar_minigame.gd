extends Control
signal finalizado(resultado: bool)

# === NODOS ===
@onready var zona_jugador = $ZonaJugador
@onready var zona_pez = $ZonaPez
@onready var progress_bar = $"../ProgressBar"
@onready var timer = $"../ProgressBar/Timer"

# === VARIABLES CONFIGURABLES ===
@export var velocidad_pez := 200.0
@export var velocidad_jugador := 400.0
@export var resiliencia := 1.0           # Afecta la variabilidad del movimiento del pez
@export var rango_colision := 50.0
@export var progreso_subida := 45.0
@export var progreso_bajada := 10.0
@export var tiempo_proteccion := 5.0
@export var limite_izquierdo := 0.0
@export var limite_derecho := 620.0

# === CONTROL DE ESTADO ===
var progreso := 0.0
var direccion_pez := 1
var velocidad_actual_pez := 0.0
var objetivo_x := 0.0
var tiempo_transcurrido := 0.0
var jugador
var caña
var anzuelo

# === BLOQUEO DE INPUTS EXTERNOS ===
func _ready():
	progress_bar.value = 0
	timer.start()
	objetivo_x = randf_range(limite_izquierdo, limite_derecho)
	velocidad_actual_pez = velocidad_pez

	jugador = get_node_or_null("/root/MainJuego/Pescador")
	caña = get_node_or_null("/root/MainJuego/Pescador/CañaPesca")
	anzuelo = get_node_or_null("/root/MainJuego/Pescador/CañaPesca/Caña/Anzuelo")
	if anzuelo and anzuelo.has_method("bloquear_por_minijuego"):
		anzuelo.bloquear_por_minijuego()
	var lanzar_boton = get_tree().root.get_node_or_null("MainJuego/CanvasLayer/InterfazUsuario/Lanzar")
	if lanzar_boton:
		lanzar_boton.disabled = true
		print("🎣 Botón 'Lanzar' desactivado durante el minijuego.")



	if jugador:
		jugador.set_process(false)
		jugador.set_physics_process(false)
	if caña:
		caña.set_process(false)
		caña.set_physics_process(false)

	# 💎 Aplicar efectos de amuletos
	Global.aplicar_efectos_minijuego(self)


func _process(delta):
	tiempo_transcurrido += delta
	_mover_pez(delta)
	_mover_jugador(delta)
	verificar_colision(delta)

# === Movimiento del pez (aleatorio, suave y dependiente de resiliencia) ===
func _mover_pez(delta):
	# Si el pez llegó cerca del objetivo, elige un nuevo destino aleatorio
	if abs(zona_pez.position.x - objetivo_x) < 10.0:
		objetivo_x = randf_range(limite_izquierdo, limite_derecho)
		# Variar la velocidad en función de la resiliencia
		velocidad_actual_pez = velocidad_pez * randf_range(0.6, 1.4) * resiliencia

	# Movimiento suave hacia el objetivo
	zona_pez.position.x = move_toward(zona_pez.position.x, objetivo_x, velocidad_actual_pez * delta)
	zona_pez.position.x = clamp(zona_pez.position.x, limite_izquierdo, limite_derecho)

# === Movimiento del jugador (solo con tecla SPACE / Action) ===
func _mover_jugador(delta):
	if Input.is_action_pressed("Action"): # ← tu keybind Space
		zona_jugador.position.x += velocidad_jugador * delta
	else:
		zona_jugador.position.x = move_toward(
			zona_jugador.position.x,
			limite_izquierdo,
			velocidad_jugador * delta * 1.5
		)
	zona_jugador.position.x = clamp(zona_jugador.position.x, limite_izquierdo, limite_derecho)

# === Lógica de colisión y progreso ===
func verificar_colision(delta):
	var distancia = abs(zona_jugador.position.x - zona_pez.position.x)
	var dentro: bool = distancia <= rango_colision

	if dentro:
		progreso += delta * progreso_subida
	elif tiempo_transcurrido > tiempo_proteccion:
		progreso -= delta * progreso_bajada

	progress_bar.value = clamp(progreso, 0, 100)

	if progress_bar.value >= 100:
		finalizar_minijuego(true)
	elif progress_bar.value <= 0:
		finalizar_minijuego(false)

# === Finaliza el minijuego ===
func finalizar_minijuego(resultado: bool):
	timer.stop()

	# 🔓 Restaurar movimiento y entrada del jugador y la caña
	if jugador:
		jugador.set_process(true)
		jugador.set_physics_process(true)
	if caña:
		caña.set_process(true)
		caña.set_physics_process(true)

	print("🎮 Minijuego finalizado → Resultado:", resultado)
	print("🧩 [DEBUG] Emisión de señal 'finalizado' desde minijuego.gd")
	print("   🔹 Nodo actual:", self)
	print("   🔹 Resultado:", resultado)
	print("   🔹 Timer activo:", timer.is_stopped() == false)
	print("   🔹 ProgressBar valor:", progress_bar.value)
	print("   🔹 get_parent():", get_parent())

	# 🚫 Evitar emitir la señal más de una vez
	if self.has_meta("finalizado_emitido") and self.get_meta("finalizado_emitido"):
		print("⚠️ Señal 'finalizado' ya emitida, ignorando segunda llamada.")
		return
	self.set_meta("finalizado_emitido", true)

	# 🎯 Emitimos la señal al anzuelo
	emit_signal("finalizado", resultado)

	# ❌ Si perdió, liberar pez y desbloquear UI del anzuelo
	if not resultado:
		var anz = anzuelo if anzuelo else get_tree().get_root().get_node_or_null("MainJuego/Pescador/CañaPesca/Caña/Anzuelo")
		if anz and anz.has_method("liberar_pez"):
			anz.liberar_pez()
		if anzuelo and anzuelo.has_method("desbloquear_por_minijuego"):
			anzuelo.desbloquear_por_minijuego()

	# 🔹 Ocultar el minijuego completo (incluye ProgressBar)
	var root_minijuego = get_parent()
	if root_minijuego:
		root_minijuego.visible = false

	# 🕐 Esperar un segundo antes de eliminarlo completamente
	await get_tree().create_timer(1.0).timeout

	# 🧭 Notificar a la caña directamente antes de destruir el minijuego
	var caña = get_tree().get_root().get_node_or_null("MainJuego/CañaPesca")
	if caña and caña.has_method("_on_minijuego_finalizado"):
		caña._on_minijuego_finalizado(resultado)

	# 🔓 Rehabilitar el botón de lanzar al terminar el minijuego
	var lanzar_boton = get_tree().root.get_node_or_null("MainJuego/CanvasLayer/InterfazUsuario/Lanzar")
	if lanzar_boton:
		lanzar_boton.disabled = false
		print("✅ Botón 'Lanzar' reactivado tras finalizar minijuego.")

	# 🧹 Eliminar el minijuego de la escena
	if root_minijuego:
		root_minijuego.queue_free()
