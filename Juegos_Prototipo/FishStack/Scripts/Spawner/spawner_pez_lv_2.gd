extends Area2D

# ===========================================================
# 🐠 SISTEMA DE SPAWN DE PECES (Nivel 2)
# ===========================================================

# --- Peces de este nivel ---
var fish_scenes: Array = [
	load("res://Scene/Peces/Ballena.tscn"),
	load("res://Scene/Peces/Orca.tscn"),
	load("res://Scene/Peces/Crocodilo.tscn"),
	load("res://Scene/Peces/Marciano.tscn"),
	load("res://Scene/Peces/Delfin.tscn")
]

# --- Sistema de probabilidades para Layer 2 ---
var fish_probabilities: Array = [
	0.40,  # Ballena
	0.25,  # Orca
	0.15,  # Crocodilo
	0.20,  # Maricano
	0.50   # Delfin
]


# --- Configuración general ---
@export var spawn_delay := 1
@export var max_fish := 45


# ===========================================================
# 🧩 INICIALIZACIÓN
# ===========================================================
func _ready():
	randomize()
	var timer = Timer.new()
	timer.wait_time = spawn_delay
	timer.autostart = true
	timer.timeout.connect(spawn_fish)
	add_child(timer)


# ===========================================================
# 🐟 FUNCIÓN PRINCIPAL DE SPAWN
# ===========================================================
func spawn_fish():
	var fish_count = get_tree().current_scene.get_tree().get_nodes_in_group("peces").size()
	if fish_count >= max_fish:
		return

	var fish_scene = seleccionar_fish_scene()
	if fish_scene == null:
		print("⚠️ Escena de pez NULL")
		return

	var fish = fish_scene.instantiate()

	# ===========================================================
	# 🚫 NO ASIGNAR CALIDAD AQUÍ – YA VIENE DEL SCRIPT DEL PEZ
	# ===========================================================

	# ===========================================================
	# 🚫 Filtrar según calidad del propio pez
	# ===========================================================
	var zonas_validas = ["Común", "Raro", "Exotico", "Mitológico"]
	if not zonas_validas.has(fish.calidad):
		fish.queue_free()
		return

	# ===========================================================
	# 📌 Posición aleatoria
	# ===========================================================
	fish.global_position = get_random_point_inside_area()

	# ===========================================================
	# 📍 Nombre según escena
	# ===========================================================
	if fish_scene.resource_path.to_lower().contains("ballena"):
		fish.name = "Ballena"
	elif fish_scene.resource_path.to_lower().contains("orca"):
		fish.name = "Orca"
	elif fish_scene.resource_path.to_lower().contains("marciano"):
		fish.name = "Marciano"
	elif fish_scene.resource_path.to_lower().contains("crocodilo"):
		fish.name = "Crocodilo"
	elif fish_scene.resource_path.to_lower().contains("delfin"):
		fish.name = "Delfin"

	fish.set_meta("nombre_real", fish.name)

	# ===========================================================
	# 🐟 Agregar pez al juego
	# ===========================================================
	get_tree().current_scene.add_child(fish)
	fish.add_to_group("peces")

	print("🐬 Pez L2:", fish.name, "| Calidad:", fish.calidad)


# ===========================================================
# 🎯 Selección usando probabilidades
# ===========================================================
func seleccionar_fish_scene() -> PackedScene:
	var total_prob := 0.0
	for p in fish_probabilities:
		total_prob += p
	var roll := randf() * total_prob
	var acumulado := 0.0

	for i in fish_probabilities.size():
		acumulado += fish_probabilities[i]
		if roll <= acumulado:
			return fish_scenes[i]

	return fish_scenes[0]


# ===========================================================
# 📦 Punto aleatorio dentro del área
# ===========================================================
func get_random_point_inside_area() -> Vector2:
	if not $CollisionShape2D:
		return Vector2.ZERO

	var shape = $CollisionShape2D.shape
	var trans = $CollisionShape2D.global_transform
	var p := Vector2.ZERO

	if shape is RectangleShape2D:
		p = Vector2(
			randf_range(-shape.extents.x, shape.extents.x),
			randf_range(-shape.extents.y, shape.extents.y)
		)
	elif shape is CircleShape2D:
		var r = shape.radius * sqrt(randf())
		var ang = randf_range(0, TAU)
		p = Vector2(cos(ang), sin(ang)) * r

	return trans.origin + trans.basis_xform(p)
