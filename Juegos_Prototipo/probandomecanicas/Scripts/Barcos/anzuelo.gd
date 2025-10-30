extends Area2D

@export var velocidad_recoger := 300
@export var fuerza_lanzamiento := 1000
@export var gravedad := 1600
@export var distancia_maxima := 2500

enum Estado { INACTIVO, LANZADO, RECOGIENDO }
var estado := Estado.INACTIVO

var velocidad_anzuelo := Vector2.ZERO
var posicion_inicial := Vector2.ZERO
var pez_atrapado: Node = null

# --- Referencias ---
@onready var collision_shape := $CollisionShape2D
@onready var sprite := $Sprite2D
@onready var ui := get_tree().current_scene.get_node_or_null("CanvasLayer")
@onready var libocap := ui.get_node_or_null("LibOCap") if ui else null
@onready var inventory_ui = get_node("/root/MainJuego/CanvasLayer/InventoryUI")

# --- Datos externos ---
var Box = load("res://Scripts/FishBox.gd")
var Box_Cap = Box.new()

# ------------------------
# Inicialización
# ------------------------
func _ready():
	posicion_inicial = position
	connect("body_entered", Callable(self, "_on_body_entered"))

# ------------------------
# Colisión con peces
# ------------------------
func _on_body_entered(body):
	if body.is_in_group("peces") and pez_atrapado == null:
		var probabilidad := obtener_probabilidad_captura(body.name)
		if randf() <= probabilidad:
			pez_atrapado = body
			if body.has_method("detener_movimiento"):
				body.detener_movimiento()
			_transformar_a_bola(pez_atrapado)
			collision_shape.disabled = true
			print("🎣 ¡Captura exitosa!: ", body.name)
		else:
			print("💨 El pez escapó:", body.name)

# ------------------------
# Input
# ------------------------
func _input(event):
	if event.is_action_pressed("ui_accept"):
		match estado:
			Estado.INACTIVO:
				_lanzar()
			Estado.LANZADO:
				_empezar_recoger()

# ------------------------
# Lanzar y recoger
# ------------------------
func _lanzar():
	if estado != Estado.INACTIVO:
		return
	estado = Estado.LANZADO
	velocidad_anzuelo = Vector2(fuerza_lanzamiento, -fuerza_lanzamiento * 0.5)
	print("🏹 Lanzando anzuelo...")
	inventory_ui.visible = false

func _empezar_recoger():
	if estado != Estado.LANZADO:
		return
	estado = Estado.RECOGIENDO
	print("↩️ Recogiendo anzuelo...")

# ------------------------
# Movimiento físico
# ------------------------
func _physics_process(delta):
	match estado:
		Estado.LANZADO:
			_mover_lanzamiento(delta)
			_actualizar_pez()
		Estado.RECOGIENDO:
			_mover_recoger(delta)
			_actualizar_pez()

func _mover_lanzamiento(delta):
	velocidad_anzuelo.y += gravedad * delta
	position += velocidad_anzuelo * delta
	if position.distance_to(posicion_inicial) > distancia_maxima:
		var dir = (position - posicion_inicial).normalized()
		position = posicion_inicial + dir * distancia_maxima
		velocidad_anzuelo = Vector2.ZERO

func _mover_recoger(delta):
	if position.distance_to(posicion_inicial) > 5:
		position = position.move_toward(posicion_inicial, velocidad_recoger * delta)
	else:
		position = posicion_inicial
		velocidad_anzuelo = Vector2.ZERO
		estado = Estado.INACTIVO
		collision_shape.disabled = false

		if pez_atrapado:
			_mostrar_lib_ocap()

# ------------------------
# Mostrar el panel LibOCap
# ------------------------
func _mostrar_lib_ocap():
	if libocap:
		libocap.mostrar_panel(pez_atrapado)
		print("🐟 LibOCap visible")
	else:
		push_error("⚠️ No se encontró el nodo 'LibOCap' (CanvasLayer o nombre distinto)")

# ------------------------
# Mantener el pez pegado al anzuelo
# ------------------------
func _actualizar_pez():
	if pez_atrapado:
		pez_atrapado.global_position = global_position

# ------------------------
# Probabilidad de captura
# ------------------------
func obtener_probabilidad_captura(nombre_pez: String) -> float:
	var clave = ""
	if "Atun" in nombre_pez:
		clave = "CapAtun"
	elif "Salmon" in nombre_pez:
		clave = "CapSalmon"
	elif "Orca" in nombre_pez:
		clave = "CapOrca"
	if "Barracuda" in nombre_pez:
		clave = "CapBarracuda"
	elif "LenguadoP" in nombre_pez:
		clave = "CapLenguado"
	elif "Payaso" in nombre_pez:
		clave = "CapPayaso"
	if "Ballena" in nombre_pez:
		clave = "CapBallena"
	if Box_Cap.Porcentaje_Captura.has(clave):
		return Box_Cap.Porcentaje_Captura[clave]
	return 0.5

# ------------------------
# Transformar pez a bola
# ------------------------
func _transformar_a_bola(pez: Node):
	if pez == null:
		return
	if pez is CharacterBody2D:
		pez.velocity = Vector2.ZERO

	for c in pez.get_children():
		if c is Sprite2D or c is AnimatedSprite2D:
			c.queue_free()

	var bola = Sprite2D.new()
	bola.name = "BolaCaptura"
	bola.texture = load("res://Assets/Capturas/Captura normal.png")
	bola.scale = Vector2(0.6, 0.6)
	pez.add_child(bola)
	bola.position = Vector2.ZERO

	var tween = get_tree().create_tween()
	bola.modulate = Color(1, 1, 1, 0)
	tween.tween_property(bola, "modulate:a", 1, 0.2)
	print("✨ Pez transformado en bola de captura")
