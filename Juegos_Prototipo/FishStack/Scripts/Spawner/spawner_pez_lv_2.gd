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
	load("res://Scene/Peces/Delfin.tscn"),
	load("res://Scene/Peces/Cirujano.tscn"),
	load("res://Scene/Peces/Espada.tscn"),
	load("res://Scene/Peces/OutcomeMemories.tscn"),
	load("res://Scene/Peces/Globo.tscn"),
	load("res://Scene/Peces/Pulpo.tscn"),
	load("res://Scene/Peces/Dorado.tscn"),
	load("res://Scene/Peces/Mecha.tscn"),
	load("res://Scene/Peces/PezArgentina.tscn")
]


# --- Sistema de probabilidades para Layer 2 ---
var fish_probabilities: Array = [
	0.75, # Ballena
	0.65, # Orca
	0.65, # Crocodilo
	0.20, # Marciano
	0.75, # Delfin
	0.45, # Cirujano
	0.70, # Espada
	0.05, # OutcomeMemories
	0.70, # Globo
	0.60, # Pulpo
	0.30, # Dorado
	0.50, # Mecha
	0.07  # PezArgentina
]

# --- Configuración general ---
@export var spawn_delay := 2.25
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
	var fish_count = get_tree().get_nodes_in_group("peces_l2").size()
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
	var zonas_validas = ["Comun", "Raro", "Exotico", "Mitologico","Secreto"]
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
	var ruta = fish_scene.resource_path.to_lower()

	if ruta.contains("ballena"):
		fish.name = "Ballena"
	elif ruta.contains("orca"):
		fish.name = "Orca"
	elif ruta.contains("crocodilo"):
		fish.name = "Crocodilo"
	elif ruta.contains("marciano"):
		fish.name = "Marciano"
	elif ruta.contains("delfin"):
		fish.name = "Delfin"
	elif ruta.contains("cirujano"):
		fish.name = "Cirujano"
	elif ruta.contains("espada"):
		fish.name = "Espada"
	elif ruta.contains("outcomememories"):
		fish.name = "OutcomeMemories"
	elif ruta.contains("globo"):
		fish.name = "Globo"
	elif ruta.contains("pulpo"):
		fish.name = "Pulpo"
	elif ruta.contains("dorado"):
		fish.name = "Dorado"
	elif ruta.contains("mecha"):
		fish.name = "Mecha"
	elif ruta.contains("pezargentina"):
		fish.name = "PezArgentina"


	fish.set_meta("nombre_real", fish.name)

	# ===========================================================
	# 🐟 Agregar pez al juego
	# ===========================================================
	get_tree().current_scene.add_child(fish)
	fish.add_to_group("peces")
	fish.add_to_group("peces_l2")  # 🔥 nuevo grupo exclusivo para layer 2
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
	var col := $CollisionShape2D
	if col == null or col.shape == null:
		return Vector2.ZERO

	var shape = col.shape

	if shape is RectangleShape2D:
		var local_x = randf_range(-shape.extents.x, shape.extents.x)
		var local_y = randf_range(-shape.extents.y, shape.extents.y)
		return col.global_transform * Vector2(local_x, local_y)

	return col.global_position
