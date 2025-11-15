extends Area2D

# ===========================================================
# 🐠 SISTEMA DE SPAWN DE PECES (Nivel 3)
# ===========================================================

# --- Peces de este nivel ---
var fish_scenes: Array = [
	load("res://Scene/Peces/Coral.tscn"),
	load("res://Scene/Peces/AzulDorado.tscn"),
	load("res://Scene/Peces/CamaronPistola.tscn"),
	load("res://Scene/Peces/LoboMarino.tscn"),
	load("res://Scene/Peces/Pavo.tscn"),
	load("res://Scene/Peces/Remo.tscn"),
	load("res://Scene/Peces/RetroGlobo.tscn")
]

# --- Sistema de probabilidades para Layer 3 ---
var fish_probabilities: Array = [
	0.10,  # Coral
	0.80,  # AzulDorado
	0.70,  # CamaronPistola
	0.45,  # LoboMarino
	0.70,  # Pavo
	0.20,  # Remo
	0.50   # RetroGlobo
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

	# NO asignar calidad, ya viene del script del pez
	var zonas_validas = ["Comun", "Raro", "Exotico", "Mitologico" ,"Celestial"]
	if not zonas_validas.has(fish.calidad):
		fish.queue_free()
		return

	# Posición aleatoria
	fish.global_position = get_random_point_inside_area()

	# Asignar nombre según escena
	var path = fish_scene.resource_path.to_lower()

	if path.contains("coral"):
		fish.name = "Coral"
	elif path.contains("azuldorado"):
		fish.name = "AzulDorado"
	elif path.contains("camaronpistola"):
		fish.name = "CamaronPistola"
	elif path.contains("lobomarino"):
		fish.name = "LoboMarino"
	elif path.contains("pavo"):
		fish.name = "Pavo"
	elif path.contains("remo"):
		fish.name = "Remo"
	elif path.contains("retroglobo"):
		fish.name = "RetroGlobo"

	fish.set_meta("nombre_real", fish.name)

	# Agregar al juego
	get_tree().current_scene.add_child(fish)
	fish.add_to_group("peces")

	print("🐟 Pez L3:", fish.name, "| Calidad:", fish.calidad)


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
