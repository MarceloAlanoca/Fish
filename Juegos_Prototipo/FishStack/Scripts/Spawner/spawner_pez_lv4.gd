extends Area2D

# ===========================================================
# 🐠 SISTEMA DE SPAWN DE PECES (Nivel 4)
# ===========================================================

# --- Peces de este nivel ---
var fish_scenes: Array = [
	load("res://Scene/Peces/Cebra.tscn"),
	load("res://Scene/Peces/AbisalDemonio.tscn"),
	load("res://Scene/Peces/Gota.tscn"),
	load("res://Scene/Peces/Kraken.tscn"),
	load("res://Scene/Peces/Luciernaga.tscn"),
	load("res://Scene/Peces/Dienton.tscn"),
	load("res://Scene/Peces/Antena.tscn")
]

# --- Sistema de probabilidades para Layer 4 ---
var fish_probabilities: Array = [
	0.45,  # Cebra
	0.80,  # AbisalDemonio
	0.45,  # Gota
	0.40,  # Kraken
	0.35,  # Luciernaga
	0.35,  # Dienton
	0.40   # Antena
]


# --- Configuración general ---
@export var spawn_delay := 1.2
@export var max_fish := 55


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

	# NO asignar calidad, ya viene del script del pez
	var zonas_validas = ["Raro", "Exotico", "Mitologico" ,"Celestial", "Secreto"]
	if not zonas_validas.has(fish.calidad):
		fish.queue_free()
		return

	# Posición aleatoria
	fish.global_position = get_random_point_inside_area()

	# Detectar nombre
	var path = fish_scene.resource_path.to_lower()

	if path.contains("cebra"):
		fish.name = "Cebra"
	elif path.contains("abisaldemonio"):
		fish.name = "AbisalDemonio"
	elif path.contains("gota"):
		fish.name = "Gota"
	elif path.contains("kraken"):
		fish.name = "Kraken"
	elif path.contains("luciernaga"):
		fish.name = "Luciernaga"
	elif path.contains("dienton"):
		fish.name = "Dienton"
	elif path.contains("antena"):
		fish.name = "Antena"

	fish.set_meta("nombre_real", fish.name)

	# Agregar al juego
	get_tree().current_scene.add_child(fish)
	fish.add_to_group("peces")

	print("🐡 Pez L4:", fish.name, "| Calidad:", fish.calidad)


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
