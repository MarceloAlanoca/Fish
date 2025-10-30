extends Area2D

# ------------------------------
# Escenas de los peces (cargadas directamente)
# ------------------------------
var fish_scenes: Array = [
	load("res://Scene/ballena.tscn"), #indice 0
	load("res://Scene/orca.tscn")      # índice 1

]

# ------------------------------
# Script con porcentajes
# ------------------------------
var Box = load("res://Scripts/FishBox.gd")
var Porcentaje = Box.new()

var fish_probabilities: Array = [
	Porcentaje.PorcentajeP["PorBallena"],
	Porcentaje.PorcentajeP["PorOrca"],
	
]

# ------------------------------
# Configuración de spawn
# ------------------------------
@export var spawn_delay := 1.5     # Tiempo entre spawns
@export var max_fish := 15         # Máximo de peces activos

# ------------------------------
# Inicialización
# ------------------------------
func _ready():
	randomize()
	var timer = Timer.new()
	timer.wait_time = spawn_delay
	timer.autostart = true
	timer.timeout.connect(spawn_fish)
	add_child(timer)

# ------------------------------
# Spawn de peces
# ------------------------------
func spawn_fish():
	# Contamos solo peces activos en la escena
	var fish_count = get_tree().current_scene.get_tree().get_nodes_in_group("peces").size()
	if fish_count >= max_fish:
		return

	var fish_scene = seleccionar_fish_scene()
	if fish_scene == null:
		print("⚠️ Escena del pez es null. Revisa las rutas.")
		return

	# Instanciamos y agregamos a la escena principal
	var fish = fish_scene.instantiate()
	fish.global_position = get_random_point_inside_area()
	get_tree().current_scene.add_child(fish)
	fish.add_to_group("peces")
	print("✅ Pez spawneado:", fish.name, "en", fish.global_position)

# ------------------------------
# Selección de pez usando probabilidades
# ------------------------------
func seleccionar_fish_scene() -> PackedScene:
	var total_prob := 0.0
	for p in fish_probabilities:
		total_prob += p

	if total_prob <= 0.0:
		print("⚠️ Probabilidades no válidas, devolviendo primer pez")
		return fish_scenes[0]

	var roll := randf() * total_prob
	var acumulado := 0.0

	for i in fish_probabilities.size():
		acumulado += fish_probabilities[i]
		if roll <= acumulado:
			return fish_scenes[i]

	# fallback
	return fish_scenes[0]

# ------------------------------
# Obtener posición aleatoria dentro del área
# ------------------------------
func get_random_point_inside_area() -> Vector2:
	if not $CollisionShape2D:
		return Vector2.ZERO

	var shape = $CollisionShape2D.shape
	var shape_transform = $CollisionShape2D.global_transform
	var point := Vector2.ZERO

	if shape is RectangleShape2D:
		var extents = shape.extents
		var rand_x = randf_range(-extents.x, extents.x)
		var rand_y = randf_range(-extents.y, extents.y)
		point = Vector2(rand_x, rand_y)
	elif shape is CircleShape2D:
		var r = shape.radius * sqrt(randf())
		var angle = randf_range(0, TAU)
		point = Vector2(cos(angle), sin(angle)) * r
	else:
		print("⚠️ Shape no soportado para spawn:", shape)

	# Convertimos de local a global
	return shape_transform.origin + shape_transform.basis_xform(point)
