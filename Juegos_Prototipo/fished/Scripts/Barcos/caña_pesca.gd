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

# ==============================
# CONTROL DE INPUT (tecla "Action")
# ==============================
func disable_action(action_name: String = "Action"):
	InputMap.action_erase_event(action_name, InputEventKey.new())
	print("⛔ Acción '%s' deshabilitada temporalmente" % action_name)

func enable_action(action_name: String = "Action", key_code: int = KEY_SPACE):
	var event := InputEventKey.new()
	event.physical_keycode = key_code
	InputMap.action_add_event(action_name, event)
	print("✅ Acción '%s' reactivada" % action_name)

# ==============================
# READY
# ==============================
func _ready():
	anzuelo = $"Caña/Anzuelo"
	posicion_inicial = anzuelo.position
	print("🎣 Caña lista, control con tecla 'Action' (Espacio)")

# ==============================
# INPUT GENERAL
# ==============================
func _input(event):
	if event.is_action_pressed("Action"):
		_manejar_tiro()

# ==============================
# LÓGICA DE LANZAR / RECOGER
# ==============================
func _manejar_tiro():
	# 🔒 Bloquear acción si el minijuego está activo
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

	# 🔹 Notificar al pescador
	if pescador and pescador.has_method("_on_pesca_iniciada"):
		pescador._on_pesca_iniciada()

	if camara and "objeto_seguir" in camara:
		camara.objeto_seguir = anzuelo

	velocidad_anzuelo = Vector2(fuerza_lanzamiento, -fuerza_lanzamiento * 0.5)
	print("🏹 Lanzando anzuelo...")

func empezar_recoger():
	
	if not lanzado or recogiendo:
		print("🔎 empezar_recoger() lanzado =", lanzado, " recogiendo =", recogiendo)
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

	# ✅ Volver a seguir al pescador con la cámara
	if camara and "objeto_seguir" in camara:
		var pescador_node = get_node_or_null("/root/MainJuego/Pescador")
		if pescador_node:
			camara.objeto_seguir = pescador_node

	# ✅ Rehabilitar colisión del anzuelo
	if anzuelo and anzuelo.has_node("CollisionShape2D"):
		anzuelo.get_node("CollisionShape2D").disabled = false

	# ✅ Mostrar el panel LibOCap si hay pez capturado
	if anzuelo and anzuelo.pez_atrapado:
		var libocap = get_tree().root.get_node_or_null("MainJuego/CanvasLayer/LibOCap")
		if libocap and libocap.has_method("mostrar_panel"):
			libocap.mostrar_panel(anzuelo.pez_atrapado)
			print("📖 Panel LibOCap mostrado automáticamente al recoger el pez.")
		else:
			push_warning("⚠️ No se encontró LibOCap o no tiene mostrar_panel().")

	# ✅ Limpiar referencia al pez en la caña (ya gestionado por LibOCap)
	pez_atrapado = null
	emit_signal("pesca_terminada")

	# respaldo explícito
	if pescador and pescador.has_method("_on_pesca_terminada"):
		pescador._on_pesca_terminada()



# ==============================
# RESULTADO DEL MINIJUEGO
# ==============================
func _on_minijuego_finalizado(resultado: bool):
	print("🎮 Resultado del minijuego:", resultado)
	minijuego_activo = false
	enable_action()

	# Forzamos que la caña empiece a recoger
	lanzado = true
	recogiendo = false

	if not resultado:
		print("❌ Perdió el minijuego: la caña volverá vacía.")
		pez_atrapado = null

	# 🔁 Forzar recogida y asegurarse de restaurar movimiento al final
	empezar_recoger()

	# 🔔 Asegurar que el pescador recupere velocidad aunque algo falle
	if pescador and pescador.has_method("_on_pesca_terminada"):
		pescador._on_pesca_terminada()
