extends CharacterBody2D

var Box = load("res://Scripts/FishBox.gd")
var Box_Vel = Box.new()

var velocidad = Box_Vel.VelP["SalmonVelocity"]
var direccion: Vector2 = Vector2(1, 0)
var distancia_maxima = Box_Vel.Dist["DistSalmon"]
var distancia_recorrida: float = 0
var detenido := false # 👈 nueva variable de control

func _ready() -> void:
	add_to_group("peces")

	# 👇 Dirección inicial aleatoria (50% izquierda, 50% derecha)
	if randf() > 0.5:
		direccion = -direccion
	mirar_hacia_direccion()

func _physics_process(delta: float) -> void:
	if detenido:
		return  # 🚫 no se mueve si está detenido

	var movimiento = direccion * velocidad * delta
	position += movimiento
	distancia_recorrida += velocidad * delta

	if distancia_recorrida >= distancia_maxima:
		direccion = -direccion
		distancia_recorrida = 0
		mirar_hacia_direccion()

func mirar_hacia_direccion() -> void:
	# 🔹 Verifica si el nodo SalmonSprite2D existe
	if has_node("SalmonSprite2D"):
		var sprite = $SalmonSprite2D
		sprite.flip_h = direccion.x > 0
	elif has_node("BolaCaptura"): # 👈 si ya es una bola, ignorar flip
		return
	else:
		print("⚠️ No se encontró sprite para rotar:", self.name)

# ------------------------------
# 🚫 Método para detener el movimiento del pez
# ------------------------------
func detener_movimiento() -> void:
	velocidad = 0
	detenido = true
	set_physics_process(false) # opcional, si querés congelarlo totalmente
	print("⏸ Movimiento detenido:", name)
