extends CharacterBody2D

var Box = load("res://Scripts/FishBox.gd")
var Box_Vel = Box.new()

@export var nombre_real := "AbisalDemonio"
@export var calidad := "Exotico"
@export var vel_progresion := 1.0

# 🔦 Intensidad configurada desde código
@export var luz_intensidad := 1.5

var velocidad = Box_Vel.VelP["AbisalDemonioVelocity"]
var direccion: Vector2 = Vector2(1, 0)
var distancia_maxima = Box_Vel.Dist["DistAbisalDemonio"]
var distancia_recorrida: float = 0
var detenido := false

@onready var luz := $PointLight2D   # referencia a la luz

func _ready() -> void:
	add_to_group("peces")
	name = nombre_real
	set_meta("nombre_real", nombre_real)

	# Configurar luz inicial usando la intensidad exportada
	if luz:
		luz.energy = luz_intensidad
		# El color viene del Inspector → no se toca aquí

	# Dirección aleatoria
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

func mirar_hacia_direccion():
	var mirando_izquierda = direccion.x > 0
	
	$Sprite2D.flip_h = mirando_izquierda
	
	if mirando_izquierda:
		$LuzPivot.scale.x = -1
	else:
		$LuzPivot.scale.x = 1


func detener_movimiento():
	velocidad = 0
	detenido = true
	set_physics_process(false)

# ============================
# 🔥 Control dinámico de la luz
# ============================
func set_luz_intensidad(valor: float):
	luz_intensidad = valor
	if luz:
		luz.energy = valor

func apagar_luz():
	if luz:
		luz.energy = 0.0

func encender_luz():
	if luz:
		luz.energy = luz_intensidad
