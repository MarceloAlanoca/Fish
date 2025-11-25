extends CharacterBody2D

var Box = load("res://Scripts/FishBox.gd")
var Box_Vel = Box.new()

@export var nombre_real := "Pomni"
@export var calidad := "Secreto"
@export var vel_progresion := 0.5

# ===========================
# VELOCIDAD BASE DEL FISHBOX
# ===========================
var velocidad_base: float = float(Box_Vel.VelP["PomniVelocity"])
var velocidad: float = velocidad_base
var direccion: Vector2 = Vector2(1, 0)
var distancia_maxima: float = float(Box_Vel.Dist["DistPomni"])
var distancia_recorrida: float = 0.0
var detenido: bool = false

# ===========================
# EXPORTABLES
# ===========================
@export var sonido_cercania: AudioStreamPlayer2D
@export var zona_anzuelo: Area2D
@export var estela: CPUParticles2D
@export var pivote_estela: Node2D

# Internos
var anzuelo_cerca := false

func _ready():
	add_to_group("peces")
	name = nombre_real
	set_meta("nombre_real", nombre_real)

	# dirección random izquierda/derecha
	if randf() > 0.5:
		direccion = -direccion

	mirar_hacia_direccion()

	# conectar señales de detección del anzuelo
	if zona_anzuelo:
		zona_anzuelo.body_entered.connect(_on_anzuelo_enter)
		zona_anzuelo.body_exited.connect(_on_anzuelo_exit)


func _physics_process(delta):
	if detenido: 
		return

	# movimiento normal del pez
	var mov = direccion * velocidad * delta
	position += mov
	distancia_recorrida += velocidad * delta

	if distancia_recorrida >= distancia_maxima:
		direccion = -direccion
		distancia_recorrida = 0
		mirar_hacia_direccion()


func mirar_hacia_direccion():
	# Voltear sprite
	if $Sprite2D:
		$Sprite2D.flip_h = direccion.x > 0

	# Voltear pivote igual que PezArgentina
	if pivote_estela:
		pivote_estela.scale.x = -1 if direccion.x > 0 else 1


# ===========================
# ⭐ DETECTA EL ANZUELO CERCA
# ===========================
func _on_anzuelo_enter(body):
	# solo el anzuelo entra (por layer)
	anzuelo_cerca = true

	if sonido_cercania:
		sonido_cercania.play()

	if estela:
		estela.emitting = true


func _on_anzuelo_exit(body):
	anzuelo_cerca = false

	if sonido_cercania:
		sonido_cercania.stop()

	if estela:
		estela.emitting = false


func detener_movimiento():
	velocidad = 0
	detenido = true
	set_physics_process(false)
