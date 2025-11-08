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
# VARIABLES
# ==============================
var lanzado := false
var recogiendo := false
var en_uso := false
var minijuego_activo := false
var pez_atrapado: CharacterBody2D = null

var anzuelo: Area2D
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

	# ❌ Desactivar completamente tecla espacio
	InputMap.erase_action("ui_accept")

	# 🔗 Conectar botón "Lanzar"
	if Tirar:
		Tirar.pressed.connect(_on_tirar_boton)
	else:
		push_warning("⚠️ No se encontró el botón 'Lanzar' en el UI.")

# ==============================
# BOTÓN "LANZAR"
# ==============================
func _on_tirar_boton():
	if minijuego_activo:
		print("⏸️ No puedes lanzar ni recoger durante el minijuego.")
		return

	if not en_uso:
		lanzar_anzuelo()
	elif lanzado and not recogiendo:
		empezar_recoger()

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
