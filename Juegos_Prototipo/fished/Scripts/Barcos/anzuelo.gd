extends Area2D

# ==============================
# CONFIGURACIÓN
# ==============================
@export var velocidad_recoger := 300
@export var fuerza_lanzamiento := 1000
@export var gravedad := 1600
@export var distancia_maxima := 2000

# 💧 Variables para control del agua y botones
@export var velocidad_vertical := 250.0
@export var tiempo_necesario := 3.0

# 🌊 Límites verticales del movimiento del anzuelo dentro del agua
@export var limite_superior_base := 850.0
@export var limite_inferior_base := 3000.0

@export var velocidad_recogida_manual := 900.0  # 💨 controla qué tan rápido vuelve el anzuelo

var minijuego: Node = null
var minijuego_conectado := false
var recogida_automatica_en_progreso := false
var caña = get_node_or_null("/root/MainJuego/CañaPesca")
var recogida_automatica := false
var bloqueado_por_minijuego := false
var limite_superior := 0.0
var limite_inferior := 0.0
var subir_pulsado := false
var bajar_pulsado := false
var dentro_del_agua := false
var tiempo_en_agua := 0.0
@export var tiempo_caida_en_agua := 5.0
var tiempo_caida_actual := 0.0
var en_transicion_caida := false
var botones_mostrados := false
var puede_atrapar := true   # Bloquea capturas durante los primeros segundos bajo el agua
var botones_bloqueados := false  # Controla si los botones están deshabilitados


enum Estado { INACTIVO, LANZADO, RECOGIENDO }
var estado := Estado.INACTIVO

# ==============================
# VARIABLES
# ==============================
var velocidad_anzuelo := Vector2.ZERO
var posicion_inicial := Vector2.ZERO
var pez_atrapado: Node = null
var modificador_probabilidad := 1.0
var nombre_pez_actual: String = ""

# ==============================
# REFERENCIAS
# ==============================
@onready var collision_shape := $CollisionShape2D
@onready var sprite := $Sprite2D
@onready var libocap := ui.get_node_or_null("LibOCap") if ui else null
@onready var inventory_ui = get_node_or_null("/root/MainJuego/CanvasLayer/InventoryUI")
@onready var Tirar := get_node_or_null("/root/MainJuego/CanvasLayer/InterfazUsuario/Lanzar")
# Conexión de botones de subir/bajar
@onready var ui := get_tree().root.get_node_or_null("MainJuego/CanvasLayer/InterfazUsuario")
@onready var boton_subir := get_node_or_null("/root/MainJuego/CanvasLayer/InterfazUsuario/BotonSubir")
@onready var boton_bajar := get_node_or_null("/root/MainJuego/CanvasLayer/InterfazUsuario/BotonBajar")




# ==============================
# DATOS EXTERNOS
# ==============================
var Box = load("res://Scripts/FishBox.gd")
var Box_Cap = Box.new()

# ==============================
# MINIJUEGO
# ==============================
var minijuego_escena := preload("res://Scene/pescar_minigame.tscn")

# ==============================
# READY
# ==============================
func _ready():
	add_to_group("anzuelo")
	posicion_inicial = position
	limite_superior = limite_superior_base
	limite_inferior = limite_inferior_base
	_reset_ui_state()


	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("area_entered", Callable(self, "_on_area_entered"))
	connect("area_exited", Callable(self, "_on_area_exited"))

	# ====== CONEXIONES DE BOTONES ======
	if boton_subir:
		boton_subir.visible = false
		boton_subir.focus_mode = Control.FOCUS_ALL
		boton_subir.mouse_filter = Control.MOUSE_FILTER_STOP
		boton_subir.pressed.connect(func():
			print("⬆️ PRESSED subir")
			subir_pulsado = true
			bajar_pulsado = false)
		boton_subir.button_up.connect(func():
			print("⬆️ UP subir")
			subir_pulsado = false)

	if boton_bajar:
		boton_bajar.visible = false
		boton_bajar.focus_mode = Control.FOCUS_ALL
		boton_bajar.mouse_filter = Control.MOUSE_FILTER_STOP
		boton_bajar.pressed.connect(func():
			print("⬇️ PRESSED bajar")
			bajar_pulsado = true
			subir_pulsado = false)
		boton_bajar.button_up.connect(func():
			print("⬇️ UP bajar")
			bajar_pulsado = false)

	print("✅ Botones conectados para movimiento manual")
	print("🎣 Anzuelo listo en posición:", posicion_inicial)




	# 🔗 Conexión de botones
	if boton_subir:
		boton_subir.visible = false
		boton_subir.action_mode = BaseButton.ACTION_MODE_BUTTON_PRESS
		boton_subir.shortcut_in_tooltip = false
		boton_subir.pressed.connect(Callable(self, "_subir_caña"))

	if boton_bajar:
		boton_bajar.visible = false
		boton_bajar.action_mode = BaseButton.ACTION_MODE_BUTTON_PRESS
		boton_bajar.shortcut_in_tooltip = false
		boton_bajar.pressed.connect(Callable(self, "_bajar_caña"))

	Global.aplicar_efectos_anzuelo(self)
	print("🎣 Anzuelo listo en posición:", posicion_inicial)
	
	if boton_subir and boton_bajar:
		print("✅ Botones detectados correctamente.")
	else:
		print("❌ No se encontraron los botones del UI.")



# ==============================
# COLISIÓN CON PECES (SIN PROBABILIDAD)
# ==============================
func _on_body_entered(body):
	if not puede_atrapar:
		return  # ⛔ ignora cualquier colisión durante la caída

	if body.is_in_group("peces") and pez_atrapado == null:
		pez_atrapado = body
		nombre_pez_actual = body.name

		if body.has_method("detener_movimiento"):
			body.detener_movimiento()

		_transformar_a_bola(pez_atrapado)
		collision_shape.disabled = true
		print("🎯 ¡Pez atrapado directamente!: ", nombre_pez_actual)

		# 🚫 Desactivar límites temporales al atrapar
		_desactivar_limites_temporal()
		_iniciar_minijuego()


# ==============================
# BOTÓN "LANZAR"
# ==============================
func _on_tirar_boton():
	match estado:
		Estado.INACTIVO:
			_lanzar()
		Estado.LANZADO:
			_empezar_recoger()

# ==============================
# LANZAR Y RECOGER
# ==============================
func _lanzar():
	if estado != Estado.INACTIVO:
		return
	estado = Estado.LANZADO
	var angulo = deg_to_rad(-45)
	velocidad_anzuelo = Vector2(cos(angulo), sin(angulo)) * fuerza_lanzamiento
	print("🏹 Lanzando anzuelo...")
	if inventory_ui:
		inventory_ui.visible = false

func _empezar_recoger():
	# 🔹 Si ya está recogiendo, no repetir
	if estado == Estado.RECOGIENDO:
		print("🚫 _empezar_recoger cancelado: ya en recogida.")
		return

	print("🟠 _empezar_recoger() → inicio de recogida manual")
	# 🔹 Permite iniciar aunque estado sea INACTIVO o LANZADO
	estado = Estado.RECOGIENDO
	recogida_automatica = true
	en_transicion_caida = false
	dentro_del_agua = false
	puede_atrapar = false
	bloqueado_por_minijuego = true

	print("🔒 Bloqueando botones y desactivando límites...")
	_ocultar_botones()
	botones_mostrados = false
	if Tirar: Tirar.disabled = true
	if boton_subir: boton_subir.disabled = true
	if boton_bajar: boton_bajar.disabled = true

	limite_superior = -INF
	limite_inferior = INF
	print("✅ Limites desactivados correctamente.")



# ==============================
# MOVIMIENTO
# ==============================
func _physics_process(delta):
	# 🌊 Fase 1: transición de caída dentro del agua (caída realista sin poder pescar)
	if en_transicion_caida:
		tiempo_caida_actual += delta
		velocidad_anzuelo.y += gravedad * delta * 0.25
		position.y += velocidad_anzuelo.y * delta
		position.y = clamp(position.y, limite_superior, limite_inferior)

		if tiempo_caida_actual >= tiempo_caida_en_agua:
			en_transicion_caida = false
			dentro_del_agua = true
			puede_atrapar = true   # ✅ ahora sí puede atrapar peces
			tiempo_en_agua = 0.0
			velocidad_anzuelo = Vector2.ZERO
			print("🐟 Control manual activado tras 5 s de caída en agua.")
		return

	# 💧 Fase 2: control manual activo
	if dentro_del_agua:
	# ⛔ si está bloqueado o en recogida automática, ignorar movimiento manual
		if bloqueado_por_minijuego or recogida_automatica:
			subir_pulsado = false
			bajar_pulsado = false
			_actualizar_estado_botones()
			_comprobar_agua(delta)
			return
			
		var moved := false

		# 🔽 Movimiento con límites
		if subir_pulsado and position.y > limite_superior + 10:
			position.y -= velocidad_vertical * delta
			moved = true
		elif bajar_pulsado and position.y < limite_inferior - 10:
			position.y += velocidad_vertical * delta
			moved = true

		position.y = clamp(position.y, limite_superior, limite_inferior)

		# 🔒 Habilitar / deshabilitar botones según posición
		_actualizar_estado_botones()

		if moved:
			print("📍 Moviendo anzuelo Y =", round(position.y))

		_comprobar_agua(delta)
		return

	# 🚀 Fase 3: comportamiento normal (fuera del agua)
	if estado == Estado.LANZADO:
		_mover_lanzamiento(delta)
	elif estado == Estado.RECOGIENDO or recogida_automatica:
		_mover_recoger(delta)


	_actualizar_pez()
	_comprobar_agua(delta)



		
	if dentro_del_agua:
		print("🟢 dentro_del_agua =", dentro_del_agua, "  ↑", subir_pulsado, " ↓", bajar_pulsado)


	_actualizar_pez()
	_comprobar_agua(delta)

func _actualizar_estado_botones():
	if not boton_subir or not boton_bajar:
		return

	# Si el minijuego pide bloqueo, todo deshabilitado
	if bloqueado_por_minijuego:
		boton_subir.disabled = true
		boton_bajar.disabled = true
		return

	var en_superficie := position.y <= limite_superior + 2.0
	var en_fondo := position.y >= limite_inferior - 2.0

	boton_subir.disabled = (not dentro_del_agua) or en_superficie
	boton_bajar.disabled = (not dentro_del_agua) or en_fondo

			
# 🚫 Desactiva los límites mientras sube el anzuelo
func _desactivar_limites_temporal():
	print("🧩 Límites desactivados temporalmente (recogida o captura).")
	limite_superior = -INF
	limite_inferior = INF


func _restaurar_limites():
	print("✅ Límites restaurados (anzuelo libre).")
	limite_superior = limite_superior_base
	limite_inferior = limite_inferior_base
	_actualizar_estado_botones()


func _mover_lanzamiento(delta):
	# 🔒 Desactivar el botón de lanzar mientras el anzuelo está en el aire
	if Tirar:
		Tirar.disabled = true

	# Si está dentro del agua, detener gravedad
	if dentro_del_agua:
		velocidad_anzuelo.y = 0
		return

	# Movimiento normal de caída
	velocidad_anzuelo.y += gravedad * delta
	position += velocidad_anzuelo * delta

	# Límite máximo de distancia del lanzamiento
	if position.distance_to(posicion_inicial) > distancia_maxima:
		var dir = (position - posicion_inicial).normalized()
		position = posicion_inicial + dir * distancia_maxima
		velocidad_anzuelo = Vector2.ZERO


func _mover_recoger(delta):
	if Tirar:
		Tirar.disabled = true

	# Durante toda la recogida, forzamos límites infinitos
	limite_superior = -INF
	limite_inferior = INF
	dentro_del_agua = false

	var dist = position.distance_to(posicion_inicial)
	position = position.move_toward(posicion_inicial, velocidad_recogida_manual * delta)

	print("⬆️ [AUTO] Subiendo... Y =", round(position.y), "Distancia restante:", round(dist))

	# 💥 Si está muy cerca de la posición inicial
	if dist <= 5:
		print("✅ [AUTO] Llegó a posición inicial!")
		print("   - Estado antes:", estado, " Recogida automática:", recogida_automatica)

		position = posicion_inicial
		velocidad_anzuelo = Vector2.ZERO
		estado = Estado.INACTIVO
		recogida_automatica = false
		bloqueado_por_minijuego = false
		collision_shape.disabled = false

		_restaurar_limites()
		_reset_ui_state()

		if Tirar:
			Tirar.disabled = false

		var caña = get_node_or_null("/root/MainJuego/CañaPesca")
		if caña and caña.has_method("_on_anzuelo_recogido"):
			print("📨 [AUTO] Avisando a la caña que la recogida terminó.")
			caña._on_anzuelo_recogido()

		print("✅ [AUTO] Recogida completada con éxito.\n")



# ==============================
# MOSTRAR PANEL UI
# ==============================
func _mostrar_lib_ocap():
	if nombre_pez_actual == "" and pez_atrapado:
		nombre_pez_actual = pez_atrapado.name
	if libocap and pez_atrapado:
		libocap.mostrar_panel(pez_atrapado, nombre_pez_actual)
		print("📋 Panel LibOCap mostrado con pez:", nombre_pez_actual)
	else:
		push_error("⚠️ No se encontró 'LibOCap' o no hay pez.")

# ==============================
# PEZ PEGADO AL ANZUELO
# ==============================
func _actualizar_pez():
	if pez_atrapado:
		pez_atrapado.global_position = global_position

# ==============================
# TRANSFORMAR PEZ EN BOLA
# ==============================
func _transformar_a_bola(pez: Node):
	if pez == null:
		return
	if pez is CharacterBody2D:
		pez.velocity = Vector2.ZERO

	var shape = pez.get_node_or_null("CollisionShape2D")
	if shape:
		shape.disabled = true

	for c in pez.get_children():
		if c is Sprite2D or c is AnimatedSprite2D:
			c.queue_free()

	var bola = Sprite2D.new()
	bola.name = "BolaCaptura"
	bola.texture = load("res://Assets/Capturas/Captura normal.png")
	bola.scale = Vector2(0.6, 0.6)
	pez.add_child(bola)
	bola.position = Vector2.ZERO

	var tween = get_tree().create_tween()
	bola.modulate = Color(1, 1, 1, 0)
	tween.tween_property(bola, "modulate:a", 1, 0.2)
	print("✨ Pez transformado en bola de captura")

# ==============================
# LIBERAR / GUARDAR PEZ
# ==============================
func liberar_pez():
	if pez_atrapado:
		print("🐠 Liberando pez:", pez_atrapado.name)
		pez_atrapado.queue_free()
		call_deferred("_reset_pez")

func guardar_pez():
	if pez_atrapado:
		print("🎁 Guardando pez:", pez_atrapado.name)
		pez_atrapado.queue_free()
		call_deferred("_reset_pez")
		
func _reset_pez():
	pez_atrapado = null
	collision_shape.disabled = false

# ==============================
# MINIJUEGO
# ==============================
func _iniciar_minijuego():
	# Ocultar botones mientras dura el minijuego
	_ocultar_botones()
	if boton_subir: boton_subir.disabled = true
	if boton_bajar: boton_bajar.disabled = true
	if Tirar: Tirar.disabled = true
	print("🎣 Botón 'Lanzar' desactivado durante el minijuego.")

	# 🧩 Eliminar cualquier minijuego anterior para evitar duplicados
	if minijuego:
		if minijuego.is_connected("finalizado", Callable(self, "_on_minijuego_finalizado")):
			minijuego.disconnect("finalizado", Callable(self, "_on_minijuego_finalizado"))
		if is_instance_valid(minijuego):
			minijuego.queue_free()
		minijuego = null
		print("🧹 Minijuego anterior eliminado y desconectado.")

	# 🎮 Crear uno nuevo
	minijuego = minijuego_escena.instantiate()
	get_tree().root.add_child(minijuego)

	# 🔒 Conexión única
	if not minijuego.is_connected("finalizado", Callable(self, "_on_minijuego_finalizado")):
		minijuego.connect("finalizado", Callable(self, "_on_minijuego_finalizado"))
		minijuego_conectado = true
	print("🎮 Minijuego iniciado desde el anzuelo (conexión única creada).")

	var caña = get_node_or_null("/root/MainJuego/CañaPesca")
	if caña:
		caña.minijuego_activo = true



func _on_minijuego_finalizado(resultado: bool):
	print("\n🧩 [DEBUG] Entró a _on_minijuego_finalizado()")
	print("   🔸 minijuego:", minijuego)
	print("   🔸 minijuego_conectado:", minijuego_conectado)
	print("   🔸 recogida_automatica_en_progreso:", recogida_automatica_en_progreso)
	print("   🔸 Estado actual:", estado if "estado" in self else "no definido")

	# 🔒 Evitar ejecuciones múltiples
	if recogida_automatica_en_progreso:
		print("⚠️ Ignorado: recogida automática ya en progreso.")
		return

	recogida_automatica_en_progreso = true
	print("🎮 Minijuego finalizado → Resultado:", resultado)

	if resultado:
		print("⚙️ [AUTO] Recogida automática iniciada por minijuego.")
		recogida_automatica_por_minijuego()
	else:
		print("❌ Falló — pez liberado.")
		if pez_atrapado:
			liberar_pez()
		_reset_ui_state()
		_restaurar_limites()
		var caña = get_node_or_null("/root/MainJuego/CañaPesca")
		if caña:
			caña.minijuego_activo = false
			caña.recogiendo = false
			caña.lanzado = false

	# 🔌 Desconexión segura del minijuego
	if minijuego:
		print("🧩 Intentando desconectar 'finalizado'...")
		if minijuego.is_connected("finalizado", Callable(self, "_on_minijuego_finalizado")):
			minijuego.disconnect("finalizado", Callable(self, "_on_minijuego_finalizado"))
			print("✅ Señal 'finalizado' desconectada correctamente.")
		else:
			print("⚠️ La señal ya no estaba conectada.")
		if is_instance_valid(minijuego):
			print("🧹 Eliminando instancia de minijuego...")
			minijuego.queue_free()
		else:
			print("⚠️ Instancia inválida, ya fue destruida.")
		minijuego = null
		minijuego_conectado = false
	else:
		print("⚠️ minijuego = null (no hay referencia).")

	recogida_automatica_en_progreso = false
	print("✅ [DEBUG] Salida normal de _on_minijuego_finalizado()\n")



# 💧 Detección de entrada al agua
func _on_area_entered(area):
	print("🌊 _on_area_entered() →", area.name)

	if not area.is_in_group("agua"):
		return

	if estado == Estado.RECOGIENDO or recogida_automatica:
		print("💧 IGNORADO por estado RECOGIENDO o recogida_automatica =", recogida_automatica)
		limite_superior = -INF
		limite_inferior = INF
		dentro_del_agua = false
		return

	print("🌊 Entra al agua con estado =", estado)
	en_transicion_caida = true
	dentro_del_agua = false
	puede_atrapar = false
	botones_mostrados = false
	botones_bloqueados = false
	tiempo_caida_actual = 0.0


func _on_area_exited(area):
	print("🏝️ _on_area_exited() →", area.name)

	if not area.is_in_group("agua"):
		return

	if estado == Estado.RECOGIENDO or recogida_automatica:
		print("💧 IGNORADO por estado RECOGIENDO o recogida_automatica =", recogida_automatica)
		limite_superior = -INF
		limite_inferior = INF
		dentro_del_agua = false
		return

	print("🏖️ Salió del agua (estado =", estado, ") → restaurando límites base")
	_reset_ui_state()
	limite_superior = limite_superior_base
	limite_inferior = limite_inferior_base



# 💧 Mostrar/Ocultar botones
func _mostrar_botones():
	if boton_subir and boton_bajar:
		boton_subir.visible = true
		boton_bajar.visible = true
		botones_mostrados = true
		print("⬆️⬇️ Botones visibles")

func _ocultar_botones():
	if boton_subir and boton_bajar:
		boton_subir.visible = false
		boton_bajar.visible = false
		botones_mostrados = false

# ⬆️⬇️ Movimiento manual con límites
func _subir_caña():
	if not dentro_del_agua:
		print("⚠️ No se puede subir, el anzuelo no está en el agua.")
		return
	subir_pulsado = true
	bajar_pulsado = false

func _bajar_caña():
	if not dentro_del_agua:
		print("⚠️ No se puede bajar, el anzuelo no está en el agua.")
		return
	bajar_pulsado = true
	subir_pulsado = false


		
		# 💧 Control de tiempo dentro del agua
func _comprobar_agua(delta):
	if dentro_del_agua:
		tiempo_en_agua += delta
		if tiempo_en_agua >= tiempo_necesario and not botones_mostrados:
			_mostrar_botones()
	else:
		tiempo_en_agua = 0.0
	
func _reset_ui_state():
	subir_pulsado = false
	bajar_pulsado = false
	botones_mostrados = false
	dentro_del_agua = false
	en_transicion_caida = false
	puede_atrapar = true
	if boton_subir:
		boton_subir.visible = false
		boton_subir.disabled = false
	if boton_bajar:
		boton_bajar.visible = false
		boton_bajar.disabled = false

func bloquear_por_minijuego():
	bloqueado_por_minijuego = true
	_ocultar_botones()
	if boton_subir: boton_subir.disabled = true
	if boton_bajar: boton_bajar.disabled = true

func desbloquear_por_minijuego():
	bloqueado_por_minijuego = false
	_actualizar_estado_botones()

func recogida_automatica_por_minijuego():
	print("⚙️ [AUTO] Recogida automática iniciada por minijuego.")
	print("   - Estado actual:", estado)
	print("   - Dentro del agua:", dentro_del_agua)
	print("   - En transición caída:", en_transicion_caida)
	print("   - Posición inicial objetivo:", posicion_inicial)
	print("   - Posición actual:", position)

	recogida_automatica = true
	bloqueado_por_minijuego = true
	_desactivar_limites_temporal()
	estado = Estado.RECOGIENDO
	dentro_del_agua = false
	en_transicion_caida = false
	puede_atrapar = false
	subir_pulsado = false
	bajar_pulsado = false

	if boton_subir: boton_subir.disabled = true
	if boton_bajar: boton_bajar.disabled = true
	if Tirar: Tirar.disabled = true

	set_process(true)
	set_physics_process(true)

	if posicion_inicial == Vector2.ZERO:
		posicion_inicial = position

	print("🎯 [AUTO] Iniciando subida hacia:", posicion_inicial)

	
# 🔧 Forzar reinicio limpio del anzuelo (por ejemplo si el jugador cancela pesca)
func forzar_recogida_manual():
	print("🔄 Forzando recogida manual del anzuelo")
	_desactivar_limites_temporal()
	recogida_automatica = true
	bloqueado_por_minijuego = true
	estado = Estado.RECOGIENDO
	subir_pulsado = false
	bajar_pulsado = false
	if boton_subir: boton_subir.disabled = true
	if boton_bajar: boton_bajar.disabled = true
