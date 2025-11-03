extends CharacterBody2D

@onready var inventory_ui = get_node("/root/MainJuego/CanvasLayer/InventoryUI")
@onready var caña = get_node("/root/MainJuego/CañaPesca")  # Ajustá si tu ruta es distinta

@export var velocidad: float = 300
var puede_moverse := true
var is_facing_right := true
var pescando := false

func _ready():
	if caña:
		caña.connect("pesca_iniciada", Callable(self, "_on_pesca_iniciada"))
		caña.connect("pesca_terminada", Callable(self, "_on_pesca_terminada"))

func _process(delta):
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

	velocity = dir.normalized() * velocidad
	move_and_slide()
	_flip_sprite(dir.x)

func _flip_sprite(x):
	var sprite = $Sprite2D
	if x < 0:
		sprite.flip_h = false
	elif x > 0:
		sprite.flip_h = true

func _on_pesca_iniciada():
	pescando = true
	puede_moverse = false
	print("🚫 Movimiento bloqueado por pesca")

func _on_pesca_terminada():
	pescando = false
	puede_moverse = true
	print("✅ Movimiento restaurado")
