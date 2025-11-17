extends CharacterBody2D

@onready var inventory_ui = get_node("/root/MainJuego/CanvasLayer/InventoryUI")
@onready var caña = $"CañaPesca"  # hijo directo del Pescador
@onready var sprite_barco: Sprite2D = $"Sprite2D"   # el sprite del barco
@onready var nodo_caña: Node2D = $"CañaPesca"        # para mover la caña según el barco equipado


@export var velocidad: float = 300
@export var multiplicador_velocidad_pesca: float = 0.05  # 0 = bloqueo total, 0.1-0.3 = ralentizado

var puede_moverse := true
var is_facing_right := true
var pescando := false

func _ready():
	# 1) Cargar cañas
	Global.cargar_cañas()

	# 2) Reaplicar sprite
	Global.aplicar_sprite_guardado(self)
	_conectar_caña()

	await get_tree().process_frame

	# 3) Preparar bases
	Global._preparar_base_pescador(self)

	# 4) Reaplicar amuletos (sin barco)
	Global.reaplicar_efectos_pescador(self, false)

	# 5) Efectos de caña
	var caña_nodo = get_node_or_null("CañaPesca")
	var anzuelo_nodo = get_node_or_null("CañaPesca/Caña/Anzuelo")
	if caña_nodo and anzuelo_nodo:
		Global.aplicar_efectos_caña(caña_nodo, anzuelo_nodo, self)

	# 6) Cargar barcos
	Global.cargar_barcos()
	Global.cargar_barco_equipado()

	# 7) APLICAR BARCO (SIEMPRE AL FINAL, Y NO TOCAR MÁS LA VELOCIDAD)
	if Global.barco_equipado != "":
		Global.aplicar_barco(self)


func _conectar_caña():
	if not caña or not is_instance_valid(caña):
		caña = get_node_or_null("CañaPesca")
	if caña and not caña.is_connected("pesca_iniciada", Callable(self, "_on_pesca_iniciada")):
		caña.connect("pesca_iniciada", Callable(self, "_on_pesca_iniciada"))
		caña.connect("pesca_terminada", Callable(self, "_on_pesca_terminada"))
		print("✅ Señales de pesca conectadas correctamente.")


func _process(delta):
	# SOLO PARA DEBUG, luego lo borrás
	if Input.is_action_just_pressed("ui_accept"):
		print("🔥 DEBUG SPEED:", velocidad)


	if Input.is_action_just_pressed("ui_left"):
		inventory_ui.visible = true
	if Input.is_action_just_pressed("ui_right"):
		inventory_ui.visible = false

	if not puede_moverse:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var dir = Vector2.ZERO
	if Input.is_action_pressed("Move_D"):
		dir.x += 1
	if Input.is_action_pressed("Move_A"):
		dir.x -= 1


	var speed := self.velocidad  

	if pescando:
		speed *= multiplicador_velocidad_pesca

	velocity = dir.normalized() * speed
	move_and_slide()
	_flip_sprite(dir.x)


func _flip_sprite(x):
	var sprite = $Sprite2D
	if x < 0:
		sprite.flip_h = false
	elif x > 0:
		sprite.flip_h = true

# ==========================================
# EVENTOS DE PESCA
# ==========================================
func _on_pesca_iniciada():
	pescando = true
	if multiplicador_velocidad_pesca <= 0.0:
		puede_moverse = false
	print("🚫 Movimiento ralentizado/bloqueado por pesca")

func _on_pesca_terminada():
	pescando = false
	puede_moverse = true
	print("✅ Movimiento restaurado después de la pesca")
