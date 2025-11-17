extends Area2D

# ===========================================================
# 🐠 SISTEMA DE SPAWN DE PECES (Nivel 1 - Superficial)
# ===========================================================

# --- Peces de este nivel ---
var fish_scenes: Array = [
	load("res://Scene/Peces/Atun.tscn"),
	load("res://Scene/Peces/Salmon.tscn"),
	load("res://Scene/Peces/Barracuda.tscn"),
	load("res://Scene/Peces/Payaso.tscn"),
	load("res://Scene/Peces/Lenguado.tscn"),
	load("res://Scene/Peces/Bordo.tscn")
]

@export var spawn_delay := 1.0
@export var max_fish := 35


# ===========================================================
# 🧩 Inicialización
# ===========================================================
func _ready():
	randomize()
	var timer = Timer.new()
	timer.wait_time = spawn_delay
	timer.autostart = true
	timer.timeout.connect(spawn_fish)
	add_child(timer)


# ===========================================================
# 🐟 Función principal de spawn
# ===========================================================
func spawn_fish():
	# Evita sobrepoblación global
	var fish_count = get_tree().current_scene.get_tree().get_nodes_in_group("peces").size()
	if fish_count >= max_fish:
		return

	# Elegir pez aleatorio
	var fish_scene = fish_scenes.pick_random()
	if fish_scene == null:
		return

	var fish = fish_scene.instantiate()

	# ===========================================================
	# 🚫 YA NO ASIGNAMOS CALIDAD ALEATORIA
	# La calidad viene del propio script del pez
	# ===========================================================

	# ===========================================================
	# 🚫 Filtrar peces que NO pertenecen a esta zona
	# ===========================================================
	var zonas_validas = ["Común", "Raro", "Exótico"]
	
	if not zonas_validas.has(fish.calidad):
		fish.queue_free()
		return

	# ===========================================================
	# 📍 Asignar nombre del pez según su escena
	# ===========================================================
	var ruta = fish_scene.resource_path.to_lower()
	
	if ruta.contains("atun"):
		fish.name = "Atun"
	elif ruta.contains("salmon"):
		fish.name = "Salmon"
	elif ruta.contains("barracuda"):
		fish.name = "Barracuda"
	elif ruta.contains("payaso"):
		fish.name = "Payaso"
	elif ruta.contains("lenguado"):
		fish.name = "Lenguado"
	elif ruta.contains("bordo"):
		fish.name = "Bordo"
	else:
		fish.name = "Desconocido"
	
	fish.set_meta("nombre_real", fish.name)

	# ===========================================================
	# 📌 Posición aleatoria dentro del área del spawner
	# ===========================================================
	fish.global_position = get_random_point_inside_area()

	# Agregar el pez a la escena
	get_tree().current_scene.add_child(fish)
	fish.add_to_group("peces")

	print("🐟 Pez L1:", fish.name, "| Calidad:", fish.calidad)


# ===========================================================
# 📦 Generar punto aleatorio dentro del área
# ===========================================================
func get_random_point_inside_area() -> Vector2:
	if not $CollisionShape2D:
		return Vector2.ZERO

	var shape = $CollisionShape2D.shape
	var t = $CollisionShape2D.global_transform
	var p := Vector2.ZERO

	if shape is RectangleShape2D:
		p = Vector2(
			randf_range(-shape.extents.x, shape.extents.x),
			randf_range(-shape.extents.y, shape.extents.y)
		)
	elif shape is CircleShape2D:
		var r = shape.radius * sqrt(randf())
		var a = randf_range(0, TAU)
		p = Vector2(cos(a), sin(a)) * r

	return t.origin + t.basis_xform(p)
