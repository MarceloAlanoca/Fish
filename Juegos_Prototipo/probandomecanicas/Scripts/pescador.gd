extends CharacterBody2D

@onready var inventory_ui = get_node("/root/MainJuego/CanvasLayer/InventoryUI")  # ruta a tu InventoryUI
@export var velocidad: float = 300
var puede_moverse := true
var is_facing_right := true



func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_left"):
		inventory_ui.visible = true
	if Input.is_action_just_pressed("ui_right"):
		inventory_ui.visible = false

	if Input.is_action_just_pressed("ui_accept"):
		puede_moverse = !puede_moverse


	if not puede_moverse:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var direccion = Vector2.ZERO
	if Input.is_action_pressed("Move_D"):
		direccion.x += 1
	if Input.is_action_pressed("Move_A"):
		direccion.x -= 1

	direccion = direccion.normalized()
	velocity = direccion * velocidad
	move_and_slide()

	_flip_sprite(direccion.x)

func _flip_sprite(direccion_x: float):
	var sprite = $Sprite2D  # Cambia si tu sprite está en otra ruta
	if direccion_x < 0 and not is_facing_right:
		$Sprite2D.flip_h = false
		is_facing_right = true
	elif direccion_x > 0 and is_facing_right:
		$Sprite2D.flip_h = true
		is_facing_right = false


	
