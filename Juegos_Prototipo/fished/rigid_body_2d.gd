extends Node2D

@export var fuerza_lanzamiento = 900
@export var posicion_inicial = Vector2.ZERO

var lanzado = false
var anzuelo: RigidBody2D

func _ready():
	# Referencia al RigidBody2D Anzuelo
	anzuelo = $Anzuelo

	# Posición inicial (puedes ajustar donde está la caña)
	anzuelo.position = posicion_inicial
	
	# Poner anzuelo congelado y sin gravedad inicialmente
	anzuelo.freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC
	anzuelo.gravity_scale = 0
	anzuelo.linear_velocity = Vector2.ZERO
	anzuelo.angular_velocity = 0

func _input(event):
	if event.is_action_pressed("ui_accept"):
		if lanzado:
			recoger_anzuelo()
		else:
			lanzar_anzuelo()

func lanzar_anzuelo():
	lanzado = true
	anzuelo.freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC  # Activar física (si da error, simplemente no cambiar freeze_mode)
	anzuelo.gravity_scale = 1
	anzuelo.position = posicion_inicial
	anzuelo.linear_velocity = Vector2.ZERO
	anzuelo.angular_velocity = 0

	var direccion = Vector2.RIGHT  # Cambia esto para lanzar hacia donde quieras
	anzuelo.apply_impulse(Vector2.ZERO, direccion * fuerza_lanzamiento)

func recoger_anzuelo():
	lanzado = false
	anzuelo.freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC  # Congelar y controlar manualmente
	anzuelo.gravity_scale = 0
	anzuelo.linear_velocity = Vector2.ZERO
	anzuelo.angular_velocity = 0
	anzuelo.position = posicion_inicial
