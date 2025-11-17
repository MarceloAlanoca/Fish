extends Control

var inventario: Array = []

# -------------------------------
# Agregar un pez al primer slot vacío
# -------------------------------
func agregar_pez(sprite_texture: Texture, nombre: String) -> bool:
	for slot in $PanelContainer/GridContainer.get_children():
		# Un slot vacío tiene 0 hijos de tipo Sprite2D
		var ya_tiene_pez = false
		for child in slot.get_children():
			if child is Sprite2D:
				ya_tiene_pez = true
				break

		if not ya_tiene_pez:
			# Creamos el sprite del pez dentro del slot
			var sprite = Sprite2D.new()
			sprite.texture = sprite_texture
			sprite.scale = Vector2(0.5, 0.5)  # Ajusta según tamaño del slot
			sprite.position = Vector2.ZERO
			sprite.centered = true
			slot.add_child(sprite)

			inventario.append(nombre)
			print("✅ Pez guardado en slot:", nombre)
			return true

	print("⚠️ No hay slots libres en el inventario")
	return false

# -------------------------------
# Limpiar un slot
# -------------------------------
func limpiar_slot(slot_index: int) -> void:
	var slots = $PanelContainer/GridContainer.get_children()
	if slot_index < 0 or slot_index >= slots.size():
		push_warning("⚠️ Slot fuera de rango")
		return

	var slot = slots[slot_index]
	for child in slot.get_children():
		if child is Sprite2D:
			child.queue_free()
	inventario.remove_at(slot_index)
	print("🗑️ Slot", slot_index, "limpiado")
