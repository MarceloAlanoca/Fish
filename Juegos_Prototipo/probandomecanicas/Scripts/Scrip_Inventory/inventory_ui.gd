extends Control

@onready var slot_nodes: Array = $PanelContainer/GridContainer.get_children()

func _ready() -> void:
	for slot in slot_nodes:
		if slot.has_method("clear") and Inventory.has_method("add_slot"):
			Inventory.add_slot(slot)
