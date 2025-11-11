extends Node2D

# ==============================
# CONFIGURACIÓN
# ==============================
@export var fuerza_lanzamiento := 1200
@export var gravedad := 1800
@export var velocidad_recoger := 1400
@export var distancia_maxima := 1000
@onready var anzuelo := get_node_or_null("/root/MainJuego/Anzuelo")

var cargando_fuerza := false
var fuerza_actual := 0.0
@onready var barra_fuerza := get_node_or_null("/root/MainJuego/CanvasLayer/InterfazUsuario/BarraFuerza")

@export var fuerza_minima := 400
@export var fuerza_maxima := 1800
@export var velocidad_carga := 300.0
@export var rebote_barra := true              # activa o desactiva el efecto rebote
@export var velocidad_rebote := 200.0         # velocidad de subida/bajada de la barra
var direccion_barra := 1                      # 1 = sube, -1 = baja

func _dump_estado_cana(tag:String):
	print("[CAÑA]", tag,
		" | lanzado=", lanzado,
		" | recogiendo=", recogiendo,
		" | en_uso=", en_uso,
		" | minijuego_activo=", minijuego_activo,
		" | anzuelo_estado=", anzuelo.estado if anzuelo else "NA")

# ==============================
# SEÑALES
# ==============================
signal pesca_iniciada
signal pesca_terminada

# ==============================
# VARIABLES
# ==============================
var lanzado := false
var recogiendo := false
var en_uso := false
var minijuego_activo := false
var pez_atrapado: CharacterBody2D = null
# Espera de físicas tras el lanzamiento
var tiempo_fisicas_cana := 6.5  # segundos que dura la caída física del anzuelo
var timer_fisicas: Timer = null


var velocidad_anzuelo := Vector2.ZERO
var posicion_inicial := Vector2.ZERO

# ==============================
# REFERENCIAS
# ==============================
@onready var camara = get_node_or_null("/root/MainJuego/Camera2D")
@onready var pescador = get_node_or_null("/root/MainJuego/Pescador")
@onready var Tirar := get_node_or_null("/root/MainJuego/CanvasLayer/InterfazUsuario/Lanzar")

# ==============================
# READY
# ==============================
func _ready():
	anzuelo = $"Caña/Anzuelo"
	posicion_inicial = anzuelo.position
	print("🎣 Caña lista — control mediante botón 'Lanzar'")

	# ✅ Asegurar que 'ui_accept' exista (sin generar errores)
	if not InputMap.has_action("ui_accept"):
		InputMap.add_action("ui_accept")

	# 🔗 Conectar botón "Lanzar"
	if Tirar:
		Tirar.button_down.connect(_on_tirar_presionado)
		Tirar.button_up.connect(_on_tirar_soltado)
	else:
		push_warning("⚠️ No se encontró el botón 'Lanzar' en el UI.")
		
	_dump_estado_cana("READY")
	add_to_group("caña")


# ==============================
# LANZAR Y RECOGER
# ==============================
func lanzar_anzuelo():
	if en_uso:
		return
	lanzado = true
	recogiendo = false
	en_uso = true
	emit_signal("pesca_iniciada")

	if pescador and pescador.has_method("_on_pesca_iniciada"):
		pescador._on_pesca_iniciada()

	if camara and "objeto_seguir" in camara:
		camara.objeto_seguir = anzuelo

	velocidad_anzuelo = Vector2(fuerza_lanzamiento, -fuerza_lanzamiento * 0.5)
	print("🏹 Lanzando anzuelo...")
	
func _on_boton_lanzar_pressed():
	if not anzuelo:
		print("⚠️ No se encontró el anzuelo desde la caña.")
		return

	if anzuelo.estado == anzuelo.Estado.LANZADO:
		print("🎣 Recogiendo — desactivando límites del anzuelo temporalmente.")
		anzuelo.botones_bloqueados = false
		if anzuelo.boton_subir: anzuelo.boton_subir.disabled = true
		if anzuelo.boton_bajar: anzuelo.boton_bajar.disabled = true

		anzuelo.limite_superior = -INF
		anzuelo.limite_inferior = INF
		anzuelo._empezar_recoger()

	elif anzuelo.estado == anzuelo.Estado.INACTIVO:
		print("🏹 Lanzando anzuelo...")
		anzuelo._lanzar()


func empezar_recoger():
	if not lanzado or recogiendo: return
	recogiendo = true
	_dump_estado_cana("empezar_recoger -> recogiendo=TRUE")


# ==============================
# FÍSICAS
# ==============================
func _physics_process(delta):
	# ==============================
	# 🎯 CONTROL DE FUERZA DE LANZAMIENTO
	# ==============================
	if cargando_fuerza:
		if rebote_barra:
			fuerza_actual += velocidad_rebote * direccion_barra * delta
			if fuerza_actual >= 100:
				fuerza_actual = 100
				direccion_barra = -1  # cambia dirección al llegar arriba
			elif fuerza_actual <= 0:
				fuerza_actual = 0
				direccion_barra = 1   # cambia dirección al llegar abajo
		else:
			fuerza_actual = min(fuerza_actual + velocidad_carga * delta, 100)

		if barra_fuerza:
			barra_fuerza.value = fuerza_actual

			# Cambiar color dinámicamente según la fuerza
			var color := Color.WHITE
			if fuerza_actual < 33:
				color = Color(0.2, 0.8, 1.0)  # celeste
			elif fuerza_actual < 66:
				color = Color(1.0, 0.9, 0.3)  # amarillo
			else:
				color = Color(1.0, 0.3, 0.3)  # rojo

			barra_fuerza.add_theme_color_override("fg_color", color)


	# ==============================
	# ⚙️ MOVIMIENTO DE LA CAÑA Y ANZUELO
	# ==============================
	if lanzado and not recogiendo:
		if anzuelo:
			if anzuelo.dentro_del_agua or anzuelo.en_transicion_caida:
				# 🔹 dentro del agua → la caña NO aplica gravedad
				velocidad_anzuelo = Vector2.ZERO
			else:
				_mover_lanzamiento(delta)


func _mover_lanzamiento(delta):
	velocidad_anzuelo.y += gravedad * delta * 0.05
	anzuelo.position += velocidad_anzuelo * delta
	if anzuelo.position.distance_to(posicion_inicial) > distancia_maxima:
		var dir = (anzuelo.position - posicion_inicial).normalized()
		anzuelo.position = posicion_inicial + dir * distancia_maxima
		velocidad_anzuelo = Vector2.ZERO
	if pez_atrapado:
		pez_atrapado.global_position = anzuelo.global_position
		
	print("⚙️ Caña moviendo anzuelo Y =", anzuelo.position.y, " dentro_del_agua =", anzuelo.dentro_del_agua)
	

func _mover_recoger(delta):
	# Evitar interferencia externa
	var caña = get_node_or_null("/root/MainJuego/CañaPesca")
	if caña:
		caña.recogiendo = true
		caña.lanzado = false

	
	if anzuelo.position.distance_to(posicion_inicial) > 10.0:
		anzuelo.position = anzuelo.position.move_toward(posicion_inicial, velocidad_recoger * delta)
		if pez_atrapado:
			pez_atrapado.global_position = anzuelo.global_position
	else:
		_finalizar_pesca()

# ==============================
# FINALIZAR PESCA
# ==============================
func _finalizar_pesca():
	anzuelo.position = posicion_inicial
	velocidad_anzuelo = Vector2.ZERO
	lanzado = false
	recogiendo = false
	en_uso = false
	pez_atrapado = null
	minijuego_activo = false

	print("✅ Pesca terminada")
	emit_signal("pesca_terminada")

	if pescador and pescador.has_method("_on_pesca_terminada"):
		pescador._on_pesca_terminada()

	if camara and "objeto_seguir" in camara:
		var pescador_node = get_node_or_null("/root/MainJuego/Pescador")
		if pescador_node:
			camara.objeto_seguir = pescador_node

	if anzuelo and anzuelo.has_node("CollisionShape2D"):
		anzuelo.get_node("CollisionShape2D").disabled = false

	if anzuelo and anzuelo.pez_atrapado:
		var libocap = get_tree().root.get_node_or_null("MainJuego/CanvasLayer/LibOCap")
		if libocap and libocap.has_method("mostrar_panel"):
			var nombre_real = anzuelo.nombre_pez_actual if anzuelo.nombre_pez_actual != "" else anzuelo.pez_atrapado.name
			libocap.mostrar_panel(anzuelo.pez_atrapado, nombre_real)
			print("📖 Panel LibOCap mostrado automáticamente:", nombre_real)
		else:
			push_warning("⚠️ No se encontró LibOCap o no tiene mostrar_panel().")
	
	if Tirar:
		Tirar.disabled = false


# ==============================
# RESULTADO DEL MINIJUEGO
# ==============================
func _on_minijuego_finalizado(resultado: bool):
	print("🎮 Resultado del minijuego:", resultado)
	minijuego_activo = false

	lanzado = true
	recogiendo = false
	if not resultado:
		print("❌ Perdió el minijuego: la caña volverá vacía.")
		pez_atrapado = null

	empezar_recoger()

# caña.gd
func _on_anzuelo_recogido():
	if not anzuelo:
		return
	print("✅ Anzuelo recogido — cerrando pesca desde caña.")

	lanzado = false
	recogiendo = false
	en_uso = false
	minijuego_activo = false
	pez_atrapado = null
	if timer_fisicas:
		timer_fisicas.stop()

	_finalizar_pesca()

	if Tirar:
		Tirar.disabled = false
	print("[CAÑA] Liberada para nuevo lanzamiento | lanzado=", lanzado, " recogiendo=", recogiendo, " en_uso=", en_uso)



func _iniciar_tiempo_fisicas():
	# 🔒 Bloquea el botón 'Lanzar' mientras dura la caída del anzuelo
	if timer_fisicas:
		timer_fisicas.queue_free()

	timer_fisicas = Timer.new()
	timer_fisicas.wait_time = tiempo_fisicas_cana
	timer_fisicas.one_shot = true
	add_child(timer_fisicas)

	timer_fisicas.timeout.connect(func():
		if Tirar and not recogiendo and not minijuego_activo:
			Tirar.disabled = false
			print("✅ Botón 'Lanzar' habilitado tras", tiempo_fisicas_cana, "segundos.")
	)

	timer_fisicas.start()
	print("🕒 Botón 'Lanzar' bloqueado durante", tiempo_fisicas_cana, "segundos de físicas.")

func lanzar_con_fuerza(poder: float):
	if en_uso or minijuego_activo:
		return

	lanzado = true
	recogiendo = false
	en_uso = true
	emit_signal("pesca_iniciada")

	if pescador and pescador.has_method("_on_pesca_iniciada"):
		pescador._on_pesca_iniciada()

	if camara and "objeto_seguir" in camara:
		camara.objeto_seguir = anzuelo

	# Aplica fuerza personalizada al anzuelo
	velocidad_anzuelo = Vector2(poder, -poder * 0.5)
	print("🎣 Lanzando con poder personalizado:", poder)

	# 🔒 Bloquear el botón durante el vuelo y caída del anzuelo
	if Tirar:
		Tirar.disabled = true

	# 🕒 Reactivar luego de las físicas
	_iniciar_tiempo_fisicas()

	# ✅ Restaurar límites del anzuelo si estaban desactivados
	if anzuelo and anzuelo.has_method("_restaurar_limites"):
		anzuelo._restaurar_limites()

	velocidad_anzuelo = Vector2(poder, -poder * 0.5)
# 🔁 Reinicia su componente vertical para evitar residuos
	velocidad_anzuelo.y = -abs(velocidad_anzuelo.y)
	_dump_estado_cana("lanzar_con_fuerza:"+str(round(poder)))


		
func _on_tirar_presionado():
	if not en_uso and not recogiendo:
		cargando_fuerza = true
		fuerza_actual = 0
		if barra_fuerza:
			barra_fuerza.visible = true
			barra_fuerza.value = 0
		print("🔹 Iniciando carga de fuerza...")

func _on_tirar_soltado():
	_dump_estado_cana("_on_tirar_soltado PRE")
	if cargando_fuerza:
		var poder: float = lerp(fuerza_minima, fuerza_maxima, fuerza_actual / 100.0)
		print("🏹 Lanzamiento con fuerza:", poder)
		lanzar_con_fuerza(poder)
		cargando_fuerza = false
		if barra_fuerza:
			barra_fuerza.visible = false
				# Si el anzuelo ya fue lanzado y está activo, permitir recoger
	elif en_uso and lanzado and not recogiendo:
		print("↩️ Forzando recogida del anzuelo manualmente.")
		recogiendo = true
		if anzuelo and anzuelo.has_method("_empezar_recoger"):
			anzuelo._empezar_recoger()
	_dump_estado_cana("_on_tirar_soltado POST")
