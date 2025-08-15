extends Node2D

@export var fuerza_lanzamiento = 1000
@export var gravedad = 1500
@export var velocidad_recoger = 900
@export var distancia_maxima = 150

var lanzado = false
var recogiendo = false
var en_uso: bool = false  # Para que el jugador pueda consultar si la caña está en uso

var anzuelo: Node2D
var velocidad_anzuelo = Vector2.ZERO
var posicion_inicial = Vector2.ZERO

func _ready():
	anzuelo = $Anzuelo
	posicion_inicial = anzuelo.position

func _input(event):
	if event.is_action_pressed("ui_accept"):
		if lanzado and not recogiendo:
			empezar_recoger()
		elif recogiendo:
			lanzar_anzuelo()
		else:
			lanzar_anzuelo()

func lanzar_anzuelo():
	lanzado = true
	recogiendo = false
	en_uso = true
	velocidad_anzuelo = Vector2(fuerza_lanzamiento, -fuerza_lanzamiento * 0.5)

func empezar_recoger():
	recogiendo = true
	en_uso = true
	velocidad_anzuelo = Vector2.ZERO

func _physics_process(delta):
	if lanzado and not recogiendo:
		velocidad_anzuelo.y += gravedad * delta
		anzuelo.position += velocidad_anzuelo * delta

		var distancia_actual = anzuelo.position.distance_to(posicion_inicial)
		if distancia_actual > distancia_maxima:
			var dir = (anzuelo.position - posicion_inicial).normalized()
			anzuelo.position = posicion_inicial + dir * distancia_maxima
			velocidad_anzuelo = Vector2.ZERO

	elif recogiendo:
		var direccion = (posicion_inicial - anzuelo.position).normalized()
		var distancia = anzuelo.position.distance_to(posicion_inicial)

		if distancia > 5:
			anzuelo.position += direccion * velocidad_recoger * delta
		else:
			anzuelo.position = posicion_inicial
			velocidad_anzuelo = Vector2.ZERO
			lanzado = false
			recogiendo = false
			en_uso = false
