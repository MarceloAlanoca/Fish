extends Control
class_name Slot

@export var slot_size := Vector2(64, 64)

func _ready():
	# Establecer tamaño mínimo del slot
	custom_minimum_size = slot_size

	# Fondo visible del slot
	if get_child_count() == 0:
		var fondo = ColorRect.new()
		fondo.color = Color(0.2, 0.2, 0.2, 0.5)  # gris semitransparente
		fondo.size = slot_size
		fondo.position = Vector2.ZERO
		add_child(fondo)

# Guardar un pez en el slot
func guardar_pez(sprite_texture: Texture):
	# Eliminar sprite anterior
	for child in get_children():
		if child is Sprite2D:
			child.queue_free()

	# Crear sprite del pez
	if sprite_texture:
		var sprite = Sprite2D.new()
		sprite.texture = sprite_texture
		sprite.centered = true
		sprite.position = slot_size / 2
		# Escalamos el sprite al tamaño del slot
		var scale_x = (slot_size.x * 0.8) / sprite.texture.get_width()
		var scale_y = (slot_size.y * 0.8) / sprite.texture.get_height()
		sprite.scale = Vector2(scale_x, scale_y)
		add_child(sprite)
