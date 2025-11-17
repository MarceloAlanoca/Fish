extends CharacterBody2D
class_name PezBase

# =======================================================
# ⚙️ Variables comunes a todos los peces
# =======================================================
var Box = load("res://Scripts/FishBox.gd")
var Box_Vel = Box.new()

@export var nombre_pez := "Desconocido"
@export var velocidad := 400.0
@export var distancia_maxima := 500.0

@export var calidad := "Común"        # Común, Raro, Exótico, Mitológico, Secreto, Celestial
@export var vel_progresion := 1.0     # Afecta la barra de minijuego

var direccion: Vector2 = Vector2(1, 0)
var distancia_recorrida: float = 0
var detenido := false

# =======================================================
# 🧩 Inicialización
# =======================================================
func _ready() -> void:
	add_to_group("peces")

	if randf() > 0.5:
		direccion = -direccion
	mirar_hacia_direccion()

	aplicar_color_por_calidad()

# =======================================================
# 🌀 Movimiento del pez
# =======================================================
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

# =======================================================
# 🎨 Apariencia según calidad
# =======================================================
func aplicar_color_por_calidad():
	# Cambia color del sprite según la calidad del pez (opcional / visual)
	var sprite = get_node_or_null("%Sprite2D") # usa el nombre de tu sprite principal
	if sprite == null:
		return

	match calidad:
		"Común": sprite.modulate = Color(1, 1, 1)
		"Raro": sprite.modulate = Color(0.4, 0.7, 1)
		"Exótico": sprite.modulate = Color(0.8, 0.3, 1)
		"Mitológico": sprite.modulate = Color(1, 0.7, 0.2)
		"Secreto": sprite.modulate = Color(0.2, 1, 0.6)
		"Celestial": sprite.modulate = Color(0.6, 0.9, 1)

# =======================================================
# ↔️ Mirar en la dirección de movimiento
# =======================================================
func mirar_hacia_direccion():
	var sprite = get_node_or_null("%Sprite2D")
	if sprite:
		sprite.flip_h = direccion.x > 0

# =======================================================
# ⏸ Detener el movimiento del pez (usado al pescar)
# =======================================================
func detener_movimiento():
	detenido = true
	set_physics_process(false)
