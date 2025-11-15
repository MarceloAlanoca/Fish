extends CharacterBody2D

var Box = load("res://Scripts/FishBox.gd")
var Box_Vel = Box.new()

var velocidad = Box_Vel.VelP["PayasoVelocity"]
var direccion: Vector2 = Vector2(1, 0)
var distancia_maxima = Box_Vel.Dist["DistPayaso"]
var distancia_recorrida: float = 0
var detenido := false

# 🔹 NUEVAS VARIABLES DE CALIDAD Y PROGRESIÓN
@export var calidad := "Exotico"       # Común, Raro, Exótico, Mitológico, Secreto, Celestial
@export var vel_progresion := 1

func _ready() -> void:
	add_to_group("peces")

	# Dirección aleatoria
	if randf() > 0.5:
		direccion = -direccion
	mirar_hacia_direccion()

	# ❌ ELIMINAMOS EL BLOQUE DE COLOR
	# Esto permite mantener el color original del sprite

func _physics_process(delta: float) -> void:
	if detenido:
		return

	var movimiento = direccion * velocidad * delta
	position += movimiento
	distancia_recorrida += velocidad * delta

	if distancia_recorrida >= distancia_maxima:
		direccion = -direccion
		distancia_recorrida = 0
		mirar_hacia_direccion()

func mirar_hacia_direccion() -> void:
	if has_node("Sprite2D"):
		$Sprite2D.flip_h = direccion.x > 0

func detener_movimiento() -> void:
	detenido = true
	set_physics_process(false)
	print("⏸ Pez detenido:", name)
