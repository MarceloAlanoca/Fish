extends CharacterBody2D

@export var velocidad: float = 300
var puede_moverse := true
var is_facing_right := true

func _process(delta):
	# Alternar bloqueo al presionar ui_accept
	if Input.is_action_just_pressed("ui_accept"):
		puede_moverse = !puede_moverse

func _physics_process(delta):
	if not puede_moverse:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var direccion = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		direccion.x += 1
	if Input.is_action_pressed("ui_left"):
		direccion.x -= 1

	direccion = direccion.normalized()
	velocity = direccion * velocidad
	move_and_slide()

	_flip_sprite(direccion.x)

func _flip_sprite(direccion_x: float):
	var sprite = $Barco  # Cambia si tu sprite está en otra ruta
	if direccion_x > 0 and not is_facing_right:
		sprite.flip_h = false
		is_facing_right = true
	elif direccion_x < 0 and is_facing_right:
		sprite.flip_h = true
		is_facing_right = false
