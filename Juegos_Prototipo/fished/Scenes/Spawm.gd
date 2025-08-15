extends Node2D

@export var pez_scene: PackedScene
@export var cantidad_peces = 5

onready var zona_spawn = $Area2D
var contenedor_peces = $Pescados # Este es un Node simple

func _ready():
	for i in cantidad_peces:
		spawn_pez()

func spawn_pez():
	var pez = pez_scene.instance()
	contenedor_peces.add_child(pez)

	var shape = zona_spawn.get_node("CollisionShape2D").shape
	var rect = shape.get_rect()
	var area_global_pos = zona_spawn.global_position

	var pos_x = rand_range(rect.position.x, rect.position.x + rect.size.x)
	var pos_y = rand_range(rect.position.y, rect.position.y + rect.size.y)

	# Convertimos la posición global a local respecto a self (nodo con posición)
	pez.position = self.to_local(area_global_pos + Vector2(pos_x, pos_y))
