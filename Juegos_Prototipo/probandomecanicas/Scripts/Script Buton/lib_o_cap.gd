extends Control

var pez_actual: Node = null

@onready var boton_liberar: Button = $VBoxContainer/Liberar
@onready var boton_guardar: Button = $VBoxContainer/Capturar

func _ready() -> void:
	visible = false
	boton_liberar.pressed.connect(_on_boton_liberar_pressed)
	boton_guardar.pressed.connect(_on_boton_guardar_pressed)

func mostrar_panel(pez: Node) -> void:
	if pez == null:
		return
	pez_actual = pez
	visible = true
	print("🐟 Panel activado para pez:", pez.name)

# Liberar pez
func _on_boton_liberar_pressed() -> void:
	if pez_actual and pez_actual.is_inside_tree():
		print("💨 Liberando pez:", pez_actual.name)
		pez_actual.queue_free()
	pez_actual = null
	visible = false

# Guardar pez en inventario
func _on_boton_guardar_pressed() -> void:
	if pez_actual and pez_actual.is_inside_tree():
		var sprite = pez_actual.get_node_or_null("BolaCaptura")
		if sprite and Engine.has_singleton("Inventory"):
			Inventory.add_item({
				"name": pez_actual.name,
				"icon": sprite.texture,
				"quantity": 1
			})
			pez_actual.queue_free()
	pez_actual = null
	visible = false
