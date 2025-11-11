extends CharacterBody2D

var Box = load("res://Scripts/FishBox.gd")
var Box_Vel = Box.new()

var velocidad = Box_Vel.VelP["BordoVelocity"]
var direccion: Vector2 = Vector2(1, 0)
var distancia_maxima = Box_Vel.Dist["DistBordo"]
var distancia_recorrida: float = 0
var detenido := false

# 🔹 NUEVAS VARIABLES DE CALIDAD Y PROGRESIÓN
@export var calidad := "Raro"       # Común, Raro, Exótico, Mitológico, Secreto, Celestial
@export var vel_progresion := 1.0

func _ready() -> void:
	add_to_group("peces")

	# Dirección aleatoria
	if randf() > 0.5:
		direccion = -direccion
	mirar_hacia_direccion()

	# 🔸 Color visual según la calidad (opcional, solo para debug)
	if has_node("Sprite2D"):
		var sprite = $Sprite2D
		match calidad:
			"Común": sprite.modulate = Color(1, 1, 1)
			"Raro": sprite.modulate = Color(0.4, 0.7, 1)
			"Exótico": sprite.modulate = Color(0.8, 0.3, 1)
			"Mitológico": sprite.modulate = Color(1, 0.7, 0.2)
			"Secreto": sprite.modulate = Color(0.2, 1, 0.6)
			"Celestial": sprite.modulate = Color(0.6, 0.9, 1)

func _physics_process(delta: float) -> void:
	if detenido:
		return

	var movimiento = direccion * velocidad * delta
	position += movimiento
	distancia_recorrida += velocidad * delta

	# Cambiar dirección al llegar a su distancia máxima
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
