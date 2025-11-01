extends Node2D

# ------------------------------
# Configuración editable
# ------------------------------
@export var fuerza_lanzamiento = 1400
@export var gravedad = 1800
@export var velocidad_recoger = 1400
@export var distancia_maxima = 3500

# ------------------------------
# Estado interno
# ------------------------------
var lanzado = false
var recogiendo = false
var en_uso: bool = false
var pez_atrapado: CharacterBody2D = null

# ------------------------------
# Referencias
# ------------------------------
var anzuelo: Area2D
var velocidad_anzuelo = Vector2.ZERO
var posicion_inicial = Vector2.ZERO

# ------------------------------
# Inicialización
# ------------------------------
func _ready():
	anzuelo = $"Caña/Anzuelo"
	posicion_inicial = anzuelo.position

	# Conectar señal del anzuelo
	anzuelo.connect("pez_atrapado_signal", Callable(self, "_on_anzuelo_pez_atrapado"))

# ------------------------------
# Input
# ------------------------------
func _input(event):
	if event.is_action_pressed("ui_accept"):
		if lanzado and not recogiendo:
			empezar_recoger()
		elif not lanzado:
			lanzar_anzuelo()

# ------------------------------
# Lanzar anzuelo
# ------------------------------
func lanzar_anzuelo():
	lanzado = true
	recogiendo = false
	en_uso = true
	velocidad_anzuelo = Vector2(fuerza_lanzamiento, -fuerza_lanzamiento * 0.5)
	print("🏹 Lanzando anzuelo...")

# ------------------------------
# Empezar recogida
# ------------------------------
func empezar_recoger():
	recogiendo = true
	en_uso = true
	velocidad_anzuelo = Vector2.ZERO
	print("↩️ Recogiendo anzuelo...")

# ------------------------------
# Physics process
# ------------------------------
func _physics_process(delta):
	if lanzado and not recogiendo:
		_mover_lanzamiento(delta)
	elif recogiendo:
		_mover_recoger(delta)

# ------------------------------
# Movimiento de lanzamiento
# ------------------------------
func _mover_lanzamiento(delta):
	# Aplicar gravedad
	velocidad_anzuelo.y += gravedad * delta
	anzuelo.position += velocidad_anzuelo * delta

	# Limitar distancia máxima
	var distancia_actual = anzuelo.position.distance_to(posicion_inicial)
	if distancia_actual > distancia_maxima:
		var dir = (anzuelo.position - posicion_inicial).normalized()
		anzuelo.position = posicion_inicial + dir * distancia_maxima
		velocidad_anzuelo = Vector2.ZERO

	# Mantener pez pegado
	if pez_atrapado:
		pez_atrapado.global_position = anzuelo.global_position

# ------------------------------
# Movimiento de recogida suave
# ------------------------------
func _mover_recoger(delta):
	# Mover suavemente hacia la caña
	if anzuelo.position.distance_to(posicion_inicial) > 0.1:
		anzuelo.position = anzuelo.position.move_toward(posicion_inicial, velocidad_recoger * delta)
		if pez_atrapado:
			pez_atrapado.global_position = anzuelo.global_position
	else:
		# Llegó a la caña
		anzuelo.position = posicion_inicial
		velocidad_anzuelo = Vector2.ZERO
		lanzado = false
		recogiendo = false
		en_uso = false

		# Mostrar panel de decisión si hay pez
		if pez_atrapado:
			var ui = get_tree().get_root().get_node_or_null("Pesca/CanvasLayer")
			if ui and ui.has_method("mostrar_decision"):
				ui.mostrar_decision(pez_atrapado)
			pez_atrapado = null

# ------------------------------
# Señal del anzuelo
# ------------------------------
func _on_anzuelo_pez_atrapado(pez):
	pez_atrapado = pez
	print("🎣 ¡Pez atrapado!: ", pez.name)
