extends Control
class_name InterfazUsuario

@onready var label_dinero: Label = $"Label"
@onready var boton_tienda: Button = $"Tienda"
@onready var boton_mochila: Button = $"Mochila"
@onready var panel_mochila: Panel = $PanelMochila
@onready var grid_mochila: GridContainer = $"PanelMochila/GridContainer"
@onready var barra_equipados: HBoxContainer = $"BarrasEquipados"

var amuletos_equipados: Array = []

# ======================================================
# 🧩 INICIO
# ======================================================
func _ready():
	await get_tree().process_frame  # asegura que todo esté cargadoF
	
	actualizar_label()

	if not boton_tienda.pressed.is_connected(_abrir_tienda):
		boton_tienda.pressed.connect(_abrir_tienda)
	if not boton_mochila.pressed.is_connected(_on_mochila_pressed):
		boton_mochila.pressed.connect(_on_mochila_pressed)

	if panel_mochila:
		panel_mochila.visible = false
	else:
		push_warning("⚠️ PanelMochila no encontrado en InterfazUsuario")

	# 🔁 sincronizar equipados desde Global al cargar
	amuletos_equipados = Global.amuletos_equipados.duplicate()
	_actualizar_barra_equipados()
	_aplicar_efectos_inmediatos()


# ======================================================
# 💰 SINCRONIZAR DINERO
# ======================================================
func actualizar_label():
	label_dinero.text = str(Global.doblones)

func agregar_dinero(cantidad: int):
	Global.doblones += cantidad
	actualizar_label()

# ======================================================
# 🏪 ABRIR TIENDA
# ======================================================
func _abrir_tienda():
	var tienda = load("res://Scene/tienda.tscn")
	if tienda:
		get_tree().change_scene_to_packed(tienda)
	else:
		push_error("❌ No se pudo cargar la tienda.")


# ======================================================
# 🎒 ABRIR / CERRAR MOCHILA
# ======================================================
func _on_mochila_pressed():
	if not panel_mochila:
		push_warning("⚠️ PanelMochila no está disponible")
		return

	panel_mochila.visible = !panel_mochila.visible

	if panel_mochila.visible:
		panel_mochila.mouse_filter = Control.MOUSE_FILTER_STOP
		_cargar_amuletos_mochila()
	else:
		panel_mochila.mouse_filter = Control.MOUSE_FILTER_IGNORE

	boton_mochila.release_focus() # evita activación accidental


# ======================================================
# 🧱 CARGAR AMULETOS DESDE GLOBAL
# ======================================================
func _cargar_amuletos_mochila():
	for n in grid_mochila.get_children():
		n.queue_free()

	for amuleto in Global.amuletos_comprados:
		var boton = Button.new()
		boton.text = amuleto
		boton.custom_minimum_size = Vector2(180, 60)
		boton.connect("pressed", Callable(self, "_equipar_amuletos").bind(amuleto, boton))
		
		# marcar los que ya están equipados
		if amuleto in amuletos_equipados:
			boton.modulate = Color(0.7, 1, 0.7, 1)
		
		grid_mochila.add_child(boton)


# ======================================================
# 🧿 EQUIPAR / DESEQUIPAR AMULETOS
# ======================================================
func _equipar_amuletos(nombre: String, boton: Button):
	if nombre in amuletos_equipados:
		amuletos_equipados.erase(nombre)
		boton.modulate = Color(1, 1, 1, 1)
	else:
		if amuletos_equipados.size() >= 3:
			print("⚠️ Solo puedes equipar 3 amuletos a la vez")
			return
		amuletos_equipados.append(nombre)
		boton.modulate = Color(0.7, 1, 0.7, 1)

	# 🔄 sincronizar con Global y aplicar efectos
	Global.amuletos_equipados = amuletos_equipados
	Global.guardar_amuletos()
	_actualizar_barra_equipados()
	_aplicar_efectos_inmediatos()


# ======================================================
# 🖼️ MOSTRAR AMULETOS EQUIPADOS EN HUD
# ======================================================
func _actualizar_barra_equipados():
	for slot in barra_equipados.get_children():
		slot.texture = null

	for i in range(amuletos_equipados.size()):
		var nombre = amuletos_equipados[i]
		var icon_path = _buscar_icono(nombre)
		if icon_path != "":
			barra_equipados.get_child(i).texture = load(icon_path)


# ======================================================
# 💎 APLICAR EFECTOS AL PESCADOR EN TIEMPO REAL
# ======================================================
func _aplicar_efectos_inmediatos():
	var pescador := get_tree().get_root().get_node_or_null("MainJuego/Pescador")
	if pescador:
		Global.reaplicar_efectos_pescador(pescador)
		print("✨ Efectos reaplicados. Equipados actuales:", Global.amuletos_equipados)


# ======================================================
# 🧭 OBTENER RUTA DE ICONO SEGÚN NOMBRE
# ======================================================
func _buscar_icono(nombre: String) -> String:
	var n = nombre.to_lower().strip_edges()

	match n:
		"amuleto común", "amuleto comun":
			return "res://Assets/Amuletos/amuletocomun.png"
		"amuleto raro":
			return "res://Assets/Amuletos/amuletoraro.png"
		"amuleto celestial":
			return "res://Assets/Amuletos/amuletocelestial.png"
		"amuleto dinerál", "amuleto diner al", "amuleto dineral":
			return "res://Assets/Amuletos/amuletomasplata.png"
		"amuleto secreto":
			return "res://Assets/Amuletos/amuletosecreto.png"
		"amuleto exótico", "amuleto exotico":
			return "res://Assets/Amuletos/amuletoexotico.png"
		_:
			push_warning("⚠️ No se encontró ícono para: %s" % nombre)
			return ""
