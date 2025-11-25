extends CharacterBody2D

var Box = load("res://Scripts/FishBox.gd")
var Box_Vel = Box.new()

@export var nombre_real := "PezArgentina"
@export var calidad := "Secreto"
@export var vel_progresion := 0.5

var velocidad_base: float = float(Box_Vel.VelP["PezArgentinaVelocity"])
var velocidad: float = velocidad_base
var direccion := Vector2(1, 0)
var distancia_maxima: float = float(Box_Vel.Dist["DistPezArgentina"])
var distancia_recorrida: float = 0.0
var detenido := false

# ===========================
# ESTELAS EXPORTABLES
# ===========================
@export var estela_celeste_1: CPUParticles2D
@export var estela_blanca: CPUParticles2D
@export var estela_celeste_2: CPUParticles2D
@export var pivote_estelas: Node2D



func _ready() -> void:
	add_to_group("peces")
	name = nombre_real

	if randf() > 0.5:
		direccion = -direccion

	_mirar()
	_encender_estelas(true)


func _physics_process(delta: float) -> void:
	if detenido:
		return

	var mov = direccion * velocidad * delta
	position += mov
	distancia_recorrida += velocidad * delta

	if distancia_recorrida >= distancia_maxima:
		direccion = -direccion
		distancia_recorrida = 0
		_mirar()


func _mirar() -> void:
	# El pez se voltea con flip_h
	if $Sprite2D:
		$Sprite2D.flip_h = direccion.x > 0

	# Voltear SOLO el pivote (las partículas siguen esto)
	if pivote_estelas:
		pivote_estelas.scale.x = -1 if direccion.x > 0 else 1

func _actualizar_direccion_estelas() -> void:
	# La estela siempre debe salir hacia ATRÁS del pez
	var dir_trail: Vector2 = -direccion.normalized()

	if estela_celeste_1:
		estela_celeste_1.direction = dir_trail
	if estela_blanca:
		estela_blanca.direction = dir_trail
	if estela_celeste_2:
		estela_celeste_2.direction = dir_trail


func detener_movimiento() -> void:
	detenido = true
	velocidad = 0
	set_physics_process(false)
	_encender_estelas(false)


func _encender_estelas(estado: bool) -> void:
	if estela_celeste_1:
		estela_celeste_1.emitting = estado
	if estela_blanca:
		estela_blanca.emitting = estado
	if estela_celeste_2:
		estela_celeste_2.emitting = estado
