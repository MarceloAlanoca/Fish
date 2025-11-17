extends Control
class_name InventoryTest

@onready var grid := $GridContainer
var slots: Array = []

# Preload del script del slot
var SlotScript = preload("res://Scripts/slot/control.gd")  # <-- Ruta donde esté Slot.gd

func _ready():
	crear_slots(5)

func crear_slots(cantidad: int):
	for i in range(cantidad):
		var slot = SlotScript.new()  # ✅ Creamos el slot desde el script
		grid.add_child(slot)
		slots.append(slot)

# Agregar pez a un slot libre
func agregar_pez(sprite_texture: Texture):
	for slot in slots:
		var tiene_sprite := false
		for child in slot.get_children():
			if child is Sprite2D:
				tiene_sprite = true
				break
		if not tiene_sprite:
			slot.guardar_pez(sprite_texture)
			print("✅ Pez guardado en slot")
			return
	print("⚠️ No hay slots libres")
