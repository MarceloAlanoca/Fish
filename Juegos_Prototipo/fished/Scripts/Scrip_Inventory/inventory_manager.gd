extends Node

# InventoryManager: escucha señales "guardar_pez" desde UIs (LibOCap u otros)
# y delega al singleton Inventory para añadir el item.

signal inventory_updated(item_data)

func _ready() -> void:
	# Intentar conectar automáticamente al nodo LibOCap en la escena actual
	var lib = get_tree().get_root().find_node("LibOCap", true, false)
	if lib and lib.has_signal("guardar_pez"):
		lib.connect("guardar_pez", Callable(self, "_on_guardar_pez"))
		print("InventoryManager: conectado a LibOCap")
	else:
		print("InventoryManager: no se encontró LibOCap o no tiene la señal 'guardar_pez'")

# Método público para que otros nodos (si es necesario) se conecten
func register_source(source: Node) -> void:
	if source and source.has_signal("guardar_pez"):
		source.connect("guardar_pez", Callable(self, "_on_guardar_pez"))
		print("InventoryManager: fuente registrada ->", source.name)
	else:
		push_warning("InventoryManager.register_source: source no válido o sin señal 'guardar_pez'")

# Maneja la petición de guardado: agrega al Inventory singleton (si existe)
func _on_guardar_pez(item_data: Dictionary) -> void:
	if not item_data or typeof(item_data) != TYPE_DICTIONARY:
		push_error("InventoryManager._on_guardar_pez: item_data inválido")
		return

	# Intentar usar singleton Inventory
	if Engine.has_singleton("Inventory"):
		Inventory.add_item(item_data)
		emit_signal("inventory_updated", item_data)
		print("InventoryManager: item guardado vía singleton Inventory ->", item_data.name)
		return

	# Si no hay singleton, intentar buscar un nodo Inventory en el árbol
	var inv_node = get_tree().get_root().find_node("Inventory", true, false)
	if inv_node and inv_node.has_method("add_item"):
		inv_node.add_item(item_data)
		emit_signal("inventory_updated", item_data)
		print("InventoryManager: item guardado en nodo Inventory ->", item_data.name)
		return

	# Si no se encontró Inventory, avisar
	push_error("InventoryManager: no se encontró 'Inventory' (ni singleton ni nodo) para guardar el item")
