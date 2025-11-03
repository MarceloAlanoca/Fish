extends Node

# Opcional: lista de peces guardados
var inventario: Array = []

func agregar_pez(sprite_texture: Texture, nombre: String) -> bool:
	# Busca el primer slot vacío
	for slot in get_node("HBoxContainer").get_children():
		if slot.get_child_count() == 0:
			var sprite = Sprite2D.new()
			sprite.texture = sprite_texture
			sprite.scale = Vector2(0.5, 0.5)  # Ajusta al tamaño del slot
			slot.add_child(sprite)
			inventario.append(nombre)
			print("✅ Pez guardado:", nombre)
			return true
	print("⚠️ No hay slots libres")
	return false

func limpiar_slot(slot_index: int) -> void:
	var slot = get_node("HBoxContainer").get_child(slot_index)
	for child in slot.get_children():
		child.queue_free()
	$CanvasLayer/InventoryUI.remove(slot_index)
