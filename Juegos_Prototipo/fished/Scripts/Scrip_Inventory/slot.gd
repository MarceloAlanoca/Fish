extends Panel

@onready var icon_node = $TextureRect
@onready var qty_label = $Label

var item_data = null  # ✅ permite null y Dictionary

func _ready() -> void:
	# Registrar en Inventory singleton si existe
	if Engine.has_singleton("Inventory"):
		Inventory.add_slot(self)

func set_item(item):
	item_data = item
	if item_data == null:
		icon_node.texture = null
		qty_label.text = ""
	else:
		icon_node.texture = item_data.icon
		qty_label.text = str(item_data.quantity) if item_data.quantity > 1 else ""
