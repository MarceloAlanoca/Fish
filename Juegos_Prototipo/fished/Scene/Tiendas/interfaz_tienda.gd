extends Control

const TIENDAS := {
	"Amuletos": "res://Scene/Tiendas/Amuletos.tscn",
	"Cañas":     "res://Scene/Tiendas/Cañas.tscn",
	"Disfraces": "res://Scene/Tiendas/Skines.tscn",
	"Barcos":    "res://Scene/Tiendas/Barcos.tscn",
}

func _ready():
	# Conexiones
	$HBoxContainer/Amuletos.pressed.connect(func(): _abrir_tienda("Amuletos"))
	$HBoxContainer/Cañas.pressed.connect(func(): _abrir_tienda("Cañas"))
	$HBoxContainer/Disfraces.pressed.connect(func(): _abrir_tienda("Disfraces"))
	$HBoxContainer/Barcos.pressed.connect(func(): _abrir_tienda("Barcos"))

	_refrescar_estado_botones()

func _abrir_tienda(nombre: String) -> void:
	var actual := _nombre_escena_actual()
	if nombre == actual:
		print("⚠️ Ya estás en la tienda de", nombre)
		return

	var ruta: String = TIENDAS.get(nombre, "")
	if ruta == "" or not ResourceLoader.exists(ruta):
		push_error("❌ Escena no encontrada para '%s' (%s)" % [nombre, ruta])
		return

	print("🛒 Cambiando a tienda:", nombre)
	get_tree().change_scene_to_file(ruta)

func _refrescar_estado_botones() -> void:
	var actual := _nombre_escena_actual()
	print("🧭 Escena actual detectada:", actual)

	for nombre in TIENDAS.keys():
		if not $HBoxContainer.has_node(nombre):
			continue
		var boton: BaseButton = $HBoxContainer.get_node(nombre)
		var es_actual: bool = (nombre == actual)
		boton.disabled = es_actual
		# Opcional: que no consuma input si es la actual
		boton.mouse_filter = Control.MOUSE_FILTER_IGNORE if es_actual else Control.MOUSE_FILTER_STOP
		boton.modulate = Color(1, 1, 1, 0.6) if es_actual else Color(1, 1, 1, 1)


# Devuelve "Amuletos", "Cañas", etc. según el .tscn actual
func _nombre_escena_actual() -> String:
	var path := get_tree().current_scene.scene_file_path
	if path.is_empty():
		# Fallback por si estás corriendo como subescena en editor
		return get_tree().current_scene.name
	return path.get_file().get_basename()
