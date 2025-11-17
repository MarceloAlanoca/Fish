extends CharacterBody2D

var Box = load("res://Scripts/FishBox.gd")
var Box_Vel = Box.new()

@export var nombre_real := "Gota"
@export var calidad := "Exotico"
@export var vel_progresion := 1.0

var velocidad = Box_Vel.VelP["GotaVelocity"]
var direccion: Vector2 = Vector2(1, 0)
var distancia_maxima = Box_Vel.Dist["DistGota"]
var distancia_recorrida: float = 0
var detenido := false

func _ready() -> void:
	add_to_group("peces")
	name = nombre_real
	set_meta("nombre_real", nombre_real)

	if randf() > 0.5:
		direccion = -direccion
	mirar_hacia_direccion()

func _physics_process(delta: float) -> void:
	if detenido: return

	var movimiento = direccion * velocidad * delta
	position += movimiento
	distancia_recorrida += velocidad * delta

	if distancia_recorrida >= distancia_maxima:
		direccion = -direccion
		distancia_recorrida = 0
		mirar_hacia_direccion()

func mirar_hacia_direccion():
	if has_node("Sprite2D"):
		$Sprite2D.flip_h = direccion.x > 0

func detener_movimiento():
	velocidad = 0
	detenido = true
	set_physics_process(false)
