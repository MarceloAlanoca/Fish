extends CharacterBody2D #Buen ejemplo

var Box = load("res://Scripts/FishBox.gd")
var Box_Vel = Box.new()

# 🔹 Parámetros base (ajustá según el pez)
var velocidad: float = Box_Vel.VelP["AtunVelocity"]
var distancia_maxima: float = Box_Vel.Dist["DistAtun"]


# 🔹 Variables internas
var direccion: Vector2 = Vector2(1, 0)
var distancia_recorrida: float = 0.0
var detenido := false

# 🔹 Propiedades globales usadas por el spawner y LibOCap
@export var nombre_real := "Atun"
@export var calidad := "Común"       # Común, Raro, Exótico, Mitológico, Secreto, Celestial
@export var vel_progresion := 1.0

func _ready() -> void:
	add_to_group("peces")
	name = nombre_real                      # asegura que el nodo tenga su nombre correcto
	set_meta("nombre_real", nombre_real)    # el panel de venta lo leerá desde aquí

	# Dirección inicial aleatoria
	if randf() > 0.5:
		direccion = -direccion
	mirar_hacia_direccion()

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
	if has_node("AtunSprite2D"):
		$AtunSprite2D.flip_h = direccion.x > 0

func detener_movimiento() -> void:
	detenido = true
	set_physics_process(false)
	print("⏸ Pez detenido:", nombre_real)
