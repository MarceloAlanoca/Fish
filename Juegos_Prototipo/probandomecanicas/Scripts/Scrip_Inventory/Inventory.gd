extends Node

# Diccionario de ítems: name -> {icon, quantity, type}
var items: Dictionary = {}  # guardamos los ítems actuales
var slots: Array = []       # referencias a los slots UI

# ------------------------------
# Registrar un slot
func add_slot(slot: Node) -> void:
	if slot not in slots:
		slots.append(slot)
	_update_ui()

# ------------------------------
# Agregar un ítem al inventario
func add_item(item: Dictionary) -> void:
	if not item.has("name"):
		push_error("Inventory.add_item: item sin 'name'")
		return

	var nombre = item.name
	if not items.has(nombre):
		items[nombre] = {
			"icon": item.get("icon", null),
			"quantity": item.get("quantity", 1),
			"type": item.get("type", nombre)
		}
	else:
		items[nombre]["quantity"] += item.get("quantity", 1)

	print("🎒 Inventory actualizado:", items)
	_update_ui()

# ------------------------------
# Actualizar todos los slots
func _update_ui() -> void:
	var i := 0
	for key in items.keys():
		if i >= slots.size():
			break
		var data = items[key]
		if slots[i].has_method("set_item"):
			slots[i].set_item({
				"name": key,
				"icon": data.get("icon", null),
				"quantity": data.get("quantity", 1),
				"type": data.get("type", key)
			})
		i += 1
