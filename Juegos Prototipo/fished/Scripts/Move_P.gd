extends CharacterBody2D

@export var move_speed: float
var Direcction := Vector2(1,0)

func _physics_process(delta):
	var direccion = Input.get_vector("Move_left","Move_right","Move_down","Move_up")
	velocity = direccion * move_speed
	move_and_slide()
	
	if direccion.length() > 0 :
		Direcction = direccion
	
	
