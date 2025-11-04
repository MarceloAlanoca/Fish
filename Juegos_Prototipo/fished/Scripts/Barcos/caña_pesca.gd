extends Node2D

# ==============================
# CONFIGURACIÓN
# ==============================
@export var fuerza_lanzamiento := 1400
@export var gravedad := 1800
@export var velocidad_recoger := 1400
@export var distancia_maxima := 3500

# ==============================
# SEÑALES
# ==============================
signal pesca_iniciada
signal pesca_terminada

# ==============================
# VARIABLES DE ESTADO
# ==============================
var lanzado := false
var recogiendo := false
var en_uso := false
var pez_atrapado: CharacterBody2D = null

var anzuelo: Area2D
var velocidad_anzuelo := Vector2.ZERO
var posicion_inicial := Vector2.ZERO
var Tirar: Button = null

# ==============================
# REFERENCIAS
# ==============================
@onready var camara = get_node_or_null("/root/MainJuego/Camera2D")

# ==============================
# READY
# ==============================
func _ready():
	anzuelo = $"Caña/Anzuelo"
	posicion_inicial = anzuelo.position

	# Conectar señal del anzuelo
	if anzuelo.has_signal("pez_atrapado_signal"):
		anzuelo.connect("pez_atrapado_signal", Callable(self, "_on_anzuelo_pez_atrapado"))

	# Buscar y conectar botón “Lanzar”
	_buscar_boton_tirar()

# ==============================
# BUSCAR BOTÓN "LANZAR"
# ==============================
func _buscar_boton_tirar():
	print("🔍 Buscando botón 'Lanzar'...")
	var posibles_rutas = [
		"/root/MainJuego/CanvasLayer/Lanzar",
		"/root/MainJuego/CanvasLayer/InterfazUsuario/Lanzar",
		"/root/MainJuego/CanvasLayer/UI/Lanzar"
	]

	for ruta in posibles_rutas:
		if has_node(ruta):
			Tirar = get_node(ruta)
			print("✅ Botón encontrado en:", ruta)
			Tirar.connect("pressed", Callable(self, "_on_tirar_pressed"))
			Tirar.focus_mode = Control.FOCUS_NONE  # Evita capturar el foco
			return

	print("⚠️ No se encontró ningún botón 'Lanzar' en las rutas conocidas.")

# ==============================
# BOTÓN PRESIONADO
# ==============================
func _on_tirar_pressed():
	_manejar_tiro()

# ==============================
# LÓGICA DE LANZAR / RECOGER
# ==============================
func _manejar_tiro():
	if not en_uso:
		lanzar_anzuelo()
		_actualizar_boton_texto("Recoger 🎣")
	elif lanzado and not recogiendo:
		empezar_recoger()
		_actualizar_boton_texto("Lanzar 🐟")

func _actualizar_boton_texto(texto: String):
	if Tirar:
		Tirar.text = texto

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

	if camara and "objeto_seguir" in camara:
		camara.objeto_seguir = anzuelo

	velocidad_anzuelo = Vector2(fuerza_lanzamiento, -fuerza_lanzamiento * 0.5)
	print("🏹 Lanzando anzuelo...")

func empezar_recoger():
	if not lanzado or recogiendo:
		return
	recogiendo = true
	print("↩️ Recogiendo anzuelo...")

# ==============================
# FÍSICAS
# ==============================
func _physics_process(delta):
	if lanzado and not recogiendo:
		_mover_lanzamiento(delta)
	elif recogiendo:
		_mover_recoger(delta)

func _mover_lanzamiento(delta):
	velocidad_anzuelo.y += gravedad * delta
	anzuelo.position += velocidad_anzuelo * delta
	if anzuelo.position.distance_to(posicion_inicial) > distancia_maxima:
		var dir = (anzuelo.position - posicion_inicial).normalized()
		anzuelo.position = posicion_inicial + dir * distancia_maxima
		velocidad_anzuelo = Vector2.ZERO
	if pez_atrapado:
		pez_atrapado.global_position = anzuelo.global_position

func _mover_recoger(delta):
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
	emit_signal("pesca_terminada")
	print("✅ Pesca terminada")

	_actualizar_boton_texto("Lanzar 🎯")

	if camara and "objeto_seguir" in camara:
		var pescador = get_node_or_null("/root/MainJuego/Pescador")
		if pescador:
			camara.objeto_seguir = pescador

	# Mostrar panel si hay pez
	if pez_atrapado:
		var ui = get_tree().get_root().get_node_or_null("Pesca/CanvasLayer")
		if ui and ui.has_method("mostrar_decision"):
			ui.mostrar_decision(pez_atrapado)
		pez_atrapado = null

# ==============================
# SEÑAL DEL ANZUELO
# ==============================
func _on_anzuelo_pez_atrapado(pez):
	pez_atrapado = pez
	print("🎣 ¡Pez atrapado!: ", pez.name)
