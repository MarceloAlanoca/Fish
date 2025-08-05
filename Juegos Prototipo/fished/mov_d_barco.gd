extends CharacterBody2D


@export var move_speed: float
func _physics_process(delta):
	move_x()
func move_x():
	var input_axis = Input.get_axis("ui_left","ui_right")
	velocity.x = input_axis * move_speed
