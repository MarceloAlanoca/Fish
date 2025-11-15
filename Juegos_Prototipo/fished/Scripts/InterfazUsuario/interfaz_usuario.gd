extends Control
class_name InterfazUsuario

@onready var label_dinero: Label = $"Label"
@onready var boton_tienda: Button = $"Tienda"
@onready var boton_mochila: Button = $"Mochila"
@onready var panel_mochila: Panel = $PanelMochila
@onready var grid_mochila: GridContainer = $"PanelMochila/GridContainerAmuletos"
@onready var barra_equipados: HBoxContainer = $"BarrasEquipados"
@onready var panel_cañas: Panel = $PanelCañas
@onready var grid_cañas: GridContainer = $"PanelCañas/GridContainerCañas"
@onready var label_profundidad: Label = $"LabelProfundidad"



var amuletos_equipados: Array = []
var anzuelo: Node = null

# ======================================================
# 🧩 INICIO
# ======================================================
func _ready():
	anzuelo = get_tree().get_root().get_node_or_null("MainJuego/Pescador/CañaPesca/Caña/Anzuelo")
	
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

	if panel_cañas:
		panel_cañas.visible = false
	else:
		push_warning("⚠️ PanelCañas no encontrado en InterfazUsuario")

	# cargar caña equipada si hay
	_actualizar_caña_equipada()

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
	var tienda = load("res://Scene/Tiendas/Amuletos.tscn")
	if tienda:
		get_tree().change_scene_to_packed(tienda)
	else:
		push_error("❌ No se pudo cargar la tienda.")


# ======================================================
# 🎒 ABRIR / CERRAR MOCHILA
# ======================================================
func _on_mochila_pressed():
	var visible_now = !panel_mochila.visible

	panel_mochila.visible = visible_now
	panel_cañas.visible = visible_now

	if visible_now:
		panel_mochila.mouse_filter = Control.MOUSE_FILTER_STOP
		panel_cañas.mouse_filter = Control.MOUSE_FILTER_STOP
		_cargar_amuletos_mochila()
		_cargar_cañas_panel()
	else:
		panel_mochila.mouse_filter = Control.MOUSE_FILTER_IGNORE
		panel_cañas.mouse_filter = Control.MOUSE_FILTER_IGNORE

	boton_mochila.release_focus()



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
		# 🧩 Reinicia valores base antes de aplicar efectos nuevos
		Global._preparar_base_pescador(pescador)
		Global.reaplicar_efectos_pescador(pescador)
		print("✨ Efectos recalculados. Amuletos activos:", Global.amuletos_equipados)



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

# ======================================================
# 🎣 PANEL DE CAÑAS
# ======================================================

func mostrar_panel_cañas():
	if not panel_cañas:
		push_warning("⚠️ PanelCañas no encontrado")
		return

	panel_cañas.visible = !panel_cañas.visible

	if panel_cañas.visible:
		_cargar_cañas_panel()
	else:
		panel_cañas.visible = false

func _cargar_cañas_panel():
	for n in grid_cañas.get_children():
		n.queue_free()

	for caña in Global.cañas_compradas:
		var boton = TextureButton.new()
		var icon_path = _buscar_icono_caña(caña)
		if icon_path != "":
			boton.texture_normal = load(icon_path)
		else:
			continue

		boton.tooltip_text = caña
		boton.custom_minimum_size = Vector2(80, 80)
		boton.connect("pressed", Callable(self, "_equipar_caña").bind(caña, boton))

		# marcar la caña equipada
		if caña == Global.caña_equipada:
			boton.modulate = Color(0.6, 1, 0.6, 1)
		else:
			boton.modulate = Color(1, 1, 1, 1)

		grid_cañas.add_child(boton)

func _equipar_caña(nombre: String, boton: TextureButton):
	var pescador := get_tree().get_root().get_node_or_null("MainJuego/Pescador")

	# 🚫 Bloquear cambio si el jugador está pescando
	if pescador and "pescando" in pescador and pescador.pescando:
		print("🚫 No puedes cambiar de caña mientras estás pescando.")
		return

	Global.caña_equipada = nombre
	Global.guardar_cañas()
	_actualizar_caña_equipada()

	# 🎨 Actualizar visualmente los botones
	for b in grid_cañas.get_children():
		b.modulate = Color(1, 1, 1, 1)
	boton.modulate = Color(0.6, 1, 0.6, 1)

	# 🎣 Reaplicar efectos (solo si no está pescando)
	var caña_nodo := get_tree().get_root().get_node_or_null("MainJuego/Pescador/CañaPesca")
	var anzuelo_nodo := get_tree().get_root().get_node_or_null("MainJuego/Pescador/CañaPesca/Caña/Anzuelo")

	if pescador and caña_nodo and anzuelo_nodo:
		Global.aplicar_efectos_caña(caña_nodo, anzuelo_nodo, pescador)

		# 🔁 refrescar límites activos del anzuelo
		if anzuelo_nodo.has_method("_restaurar_limites"):
			anzuelo_nodo._restaurar_limites()

	print("🎣 Caña equipada:", nombre)

	# 🔄 Forzar actualización visual del sprite en vivo
	if pescador:
		var sprite := pescador.get_node_or_null("CañaPesca/Caña")
		if sprite:
			var path := _buscar_icono_caña(Global.caña_equipada)
			sprite.texture = load(path)
			print("🎨 Sprite de caña actualizado desde InterfazUsuario:", path)


func _buscar_icono_caña(nombre: String) -> String:
	match nombre:
		"Caña de Madera Fuerte":
			return "res://Assets/Cañas/cañaT1.png"
		"Caña de Mango Grande":
			return "res://Assets/Cañas/cañaT2.png"
		"Caña de Acero":
			return "res://Assets/Cañas/cañaT3.png"
		"Caña Épica":
			return "res://Assets/Cañas/cañaT4.png"
		"Caña Legendaria":
			return "res://Assets/Cañas/cañaT5.png"
		_:
			return ""

func _actualizar_caña_equipada():
	var pescador := get_tree().get_root().get_node_or_null("MainJuego/Pescador")
	if not pescador:
		push_warning("⚠️ No se encontró el Pescador en la escena principal.")
		return

	var sprite := pescador.get_node_or_null("CañaPesca/Caña/Sprite2D")
	if not sprite:
		push_warning("⚠️ No se encontró el Sprite2D de la caña en el Pescador.")
		return

	var path := ""
	match Global.caña_equipada:
		"Caña de Madera Fuerte": path = "res://Assets/Cañas/cañaT1.png"
		"Caña de Mango Grande": path = "res://Assets/Cañas/cañaT2.png"
		"Caña de Acero": path = "res://Assets/Cañas/cañaT3.png"
		"Caña Épica": path = "res://Assets/Cañas/cañaT4.png"
		"Caña Legendaria": path = "res://Assets/Cañas/cañaT5.png"
		_: path = "res://Assets/Cañas/cañaT1.png"  # fallback

	sprite.texture = load(path)
	print("🎨 Sprite de caña actualizado a:", path)

func _process(_delta):
	actualizar_profundidad()


const Y_SUPERFICIE_REAL := 250.0  # <-- actualizar con tu valor exacto
const PIXELES_POR_METRO := 2.5

func actualizar_profundidad():
	if not anzuelo or not label_profundidad:
		return

	# Solo cuando realmente está sumergido
	if not anzuelo.dentro_del_agua:
		label_profundidad.text = "Profundidad: ---"
		return

	# Distancia desde la superficie real del agua
	var px: float = anzuelo.global_position.y - Y_SUPERFICIE_REAL

	if px < 0:
		px = 0

	var metros := int(px / PIXELES_POR_METRO)

	label_profundidad.text = "Profundidad: %d m" % metros
