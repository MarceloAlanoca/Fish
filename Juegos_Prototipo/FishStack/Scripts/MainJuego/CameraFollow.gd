extends Camera2D

@export var objeto_seguir:Node2D

func _process(delta):
	global_position = objeto_seguir.global_position
