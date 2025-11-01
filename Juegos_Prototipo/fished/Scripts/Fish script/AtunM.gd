extends CharacterBody2D

var Box = load("res://Scripts/FishBox.gd")
var Box_Vel = Box.new()

var velocidad = Box_Vel.VelP["AtunVelocity"]
var direccion: Vector2 = Vector2(1, 0)
var distancia_maxima = Box_Vel.Dist["DistAtun"]
var distancia_recorrida: float = 0
var detenido := false

func _ready() -> void:
	add_to_group("peces")

	if randf() > 0.5:
		direccion = -direccion
	mirar_hacia_direccion()

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
	if has_node("AtunSprite2D"):
		var sprite = $AtunSprite2D
		sprite.flip_h = direccion.x > 0
	elif has_node("BolaCaptura"):
		return
	else:
		print("⚠️ No se encontró sprite para rotar:", self.name)

func detener_movimiento() -> void:
	velocidad = 0
	detenido = true
	set_physics_process(false)
	print("⏸ Atún detenido:", name)
