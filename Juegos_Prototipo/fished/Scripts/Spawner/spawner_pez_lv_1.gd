extends Area2D

# ===========================================================
# 🐠 SISTEMA DE SPAWN DE PECES (Nivel 1 - Superficial)
# ===========================================================

# --- Escenas de peces que aparecerán en esta zona ---
var fish_scenes: Array = [
	load("res://Scene/Peces/Atun.tscn"),
	load("res://Scene/Peces/Salmon.tscn"),
	load("res://Scene/Peces/Barracuda.tscn"),
	load("res://Scene/Peces/Payaso.tscn"),
	load("res://Scene/Peces/Lenguado.tscn"),
	load("res://Scene/Peces/Bordo.tscn")
]

# --- Configuración general ---
@export var spawn_delay := 1.5     # Tiempo entre spawns
@export var max_fish := 22         # Máximo de peces activos

# --- Referencia a FishBox ---
var Box = load("res://Scripts/FishBox.gd")
var Datos = Box.new()

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
	# Evita sobrepoblación
	var fish_count = get_tree().current_scene.get_tree().get_nodes_in_group("peces").size()
	if fish_count >= max_fish:
		return

	# Escoger pez al azar
	var fish_scene = fish_scenes.pick_random()
	if fish_scene == null:
		return

	var fish = fish_scene.instantiate()

	# ===========================================================
	# 💎 Asignar calidad (según probabilidad)
	# ===========================================================
	var roll = randf()
	if roll < 0.60:
		fish.calidad = "Común"
	elif roll < 0.80:
		fish.calidad = "Raro"
	elif roll < 0.93:
		fish.calidad = "Exótico"
	elif roll < 0.985:
		fish.calidad = "Mitológico"
	elif roll < 0.997:
		fish.calidad = "Secreto"
	else:
		fish.calidad = "Celestial"

	# ===========================================================
	# 🚫 Si la calidad es demasiado alta para este nivel, no spawnear
	# ===========================================================
	var zonas_validas = ["Común", "Raro", "Exótico"]  # nivel 1 solo permite estas
	if not zonas_validas.has(fish.calidad):
		fish.queue_free()
		return  # 🟡 simplemente salimos y el timer hará el próximo spawn

	# ===========================================================
	# ⚡ Asignar velocidad de progresión (impacta el minijuego)
	# ===========================================================
	match fish.calidad:
		"Común":
			fish.vel_progresion = 1.0
		"Raro":
			fish.vel_progresion = 1.2
		"Exótico":
			fish.vel_progresion = 1.4
		"Mitológico":
			fish.vel_progresion = 1.6
		"Secreto":
			fish.vel_progresion = 1.8
		"Celestial":
			fish.vel_progresion = 2.0

	# ===========================================================
	# 📍 Configurar nombre del pez
	# ===========================================================
	var ruta: String = fish_scene.resource_path.to_lower()

	var nombre_asignado := "Desconocido"
	if ruta.contains("atun"):
		nombre_asignado = "Atun"
	elif ruta.contains("salmon"):
		nombre_asignado = "Salmon"
	elif ruta.contains("barracuda"):
		nombre_asignado = "Barracuda"
	elif ruta.contains("payaso"):
		nombre_asignado = "Payaso"
	elif ruta.contains("lenguado"):
		nombre_asignado = "Lenguado"
	elif ruta.contains("bordo"):
		nombre_asignado = "Bordo"

	fish.name = nombre_asignado
	fish.set_meta("nombre_real", nombre_asignado)


	fish.global_position = get_random_point_inside_area()
	get_tree().current_scene.add_child(fish)
	fish.add_to_group("peces")

	print("🐟 Pez spawneado:", fish.name, "| Calidad:", fish.calidad, "| VelProg:", fish.vel_progresion)


# ===========================================================
# 📦 Generar punto aleatorio dentro del área del spawner
# ===========================================================
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

	return shape_transform.origin + shape_transform.basis_xform(point)
