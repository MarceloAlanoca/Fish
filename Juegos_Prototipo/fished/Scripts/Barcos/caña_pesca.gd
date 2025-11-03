extends Node2D

@onready var camara = get_node("/root/MainJuego/Camera2D")


@export var fuerza_lanzamiento = 1400
@export var gravedad = 1800
@export var velocidad_recoger = 1400
@export var distancia_maxima = 3500


signal pesca_iniciada
signal pesca_terminada

var lanzado := false
var recogiendo := false
var en_uso := false
var pez_atrapado: CharacterBody2D = null

var anzuelo: Area2D
var velocidad_anzuelo := Vector2.ZERO
var posicion_inicial := Vector2.ZERO

func _ready():
	anzuelo = $"Caña/Anzuelo"
	posicion_inicial = anzuelo.position
	if anzuelo.has_signal("pez_atrapado_signal"):
		anzuelo.connect("pez_atrapado_signal", Callable(self, "_on_anzuelo_pez_atrapado"))

func _input(event):
	if event.is_action_pressed("ui_accept"):
		if not en_uso:
			lanzar_anzuelo()
		elif lanzado and not recogiendo:
			empezar_recoger()

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

func _finalizar_pesca():
	anzuelo.position = posicion_inicial
	velocidad_anzuelo = Vector2.ZERO
	lanzado = false
	recogiendo = false
	en_uso = false
	emit_signal("pesca_terminada")
	print("✅ Pesca terminada")

	if camara and "objeto_seguir" in camara:
		var pescador = get_node("/root/MainJuego/Pescador")
		camara.objeto_seguir = pescador

	# Mostrar panel si hay pez
	if pez_atrapado:
		var ui = get_tree().get_root().get_node_or_null("Pesca/CanvasLayer")
		if ui and ui.has_method("mostrar_decision"):
			ui.mostrar_decision(pez_atrapado)
		pez_atrapado = null

func _on_anzuelo_pez_atrapado(pez):
	pez_atrapado = pez
	print("🎣 ¡Pez atrapado!: ", pez.name)
