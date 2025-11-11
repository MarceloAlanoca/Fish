extends Control
class_name LibOCap

@onready var panel := $"."                     # Panel contenedor
@onready var boton_liberar := $VBoxContainer/Liberar
@onready var boton_vender := $VBoxContainer/Capturar
@onready var interfaz := $"../InterfazUsuario" # Referencia a la UI global si está en escena
@onready var label_mensaje := $LabelMensaje
@onready var pez_preview := $PezPreview

var pez_actual: Node = null
var anzuelo: Node = null

# Cargamos datos de precios desde FishBox
var BoxDatos = FishBox


func _ready() -> void:
	panel.visible = false

	# Buscar el anzuelo en el grupo correspondiente
	var anzuelos = get_tree().get_nodes_in_group("anzuelo")
	if anzuelos.size() > 0:
		anzuelo = anzuelos[0]
	else:
		push_warning("⚠️ No se encontró el anzuelo en grupo 'anzuelo'")

	boton_liberar.pressed.connect(_on_liberar_pressed)
	boton_vender.pressed.connect(_on_vender_pressed)


# ========================================================
# 📜 Mostrar panel cuando se pesca un pez
# ========================================================
func mostrar_panel(pez: Node, nombre_real: String = "") -> void:
	pez_actual = pez
	panel.visible = true

	var nombre_final = nombre_real

	# 🟢 Usa el nombre guardado en meta si existe
	if pez_actual.has_meta("nombre_real"):
		nombre_final = pez_actual.get_meta("nombre_real")
	elif pez_actual.name != "":
		nombre_final = pez_actual.name
	else:
		nombre_final = "Desconocido"

	nombre_final = nombre_final.strip_edges()
	nombre_final = nombre_final.rstrip("0123456789")

	var valor = calcular_precio(nombre_final)
	label_mensaje.text = "¡Pescaste un %s! 💰%d doblones" % [nombre_final, valor]


	# ✅ Texto con color aleatorio
	var colores = [
		Color(1, 0.4, 0.4),
		Color(0.4, 1, 0.4),
		Color(0.4, 0.6, 1),
		Color(1, 0.8, 0.3),
		Color(0.8, 0.5, 1)
	]
	label_mensaje.modulate = colores[randi() % colores.size()]
	label_mensaje.text = "¡Pescaste un %s! 💰%d doblones" % [nombre_final, valor]
	label_mensaje.visible = true

	# ✅ Mostrar imagen del pez, compatible con texturas normales y Atlas
	var sprite_node = pez_actual.get_node_or_null("Sprite2D")

	if sprite_node and sprite_node.texture:
		var tex = sprite_node.texture

		if tex is AtlasTexture:
			# Si es una AtlasTexture, clonar la subtextura
			var atlas_tex: AtlasTexture = tex
			var subtex = AtlasTexture.new()
			subtex.atlas = atlas_tex.atlas
			subtex.region = atlas_tex.region
			pez_preview.texture = subtex
			print("🖼️ Imagen clonada desde AtlasTexture para:", nombre_final)
		else:
			# Si es una textura normal
			pez_preview.texture = tex
			print("🖼️ Imagen copiada directamente desde el pez:", nombre_final)
	else:
		# Fallback si no tiene Sprite2D o textura
		var ruta = "res://Assets/Peces/%s.png" % nombre_final
		if ResourceLoader.exists(ruta):
			pez_preview.texture = load(ruta)
			print("🖼️ Imagen cargada por ruta:", nombre_final)
		else:
			pez_preview.texture = null
			print("🚫 No se encontró imagen para:", nombre_final)


# ========================================================
# 🐟 Liberar pez sin vender
# ========================================================
func _on_liberar_pressed() -> void:
	if anzuelo:
		anzuelo.liberar_pez()
	panel.visible = false
	print("🐠 Pez liberado")


# ========================================================
# 💰 Vender pez → sumar a Global.doblones y actualizar UI
# ========================================================
func _on_vender_pressed() -> void:
	if pez_actual:
		var nombre_guardado = pez_actual.get_meta("nombre_real", pez_actual.name)
		nombre_guardado = nombre_guardado.rstrip("0123456789")

		if anzuelo:
			anzuelo.liberar_pez()

		var valor = Global.aplicar_efectos_ganancia(calcular_precio(nombre_guardado))
		Global.doblones += valor

		print("💰 Pez vendido:", nombre_guardado, "Valor:", valor, "Total global:", Global.doblones)

		if interfaz:
			interfaz.actualizar_label()

	panel.visible = false
	pez_actual = null


# ========================================================
# 💲 Obtener precio desde FishBox
# ========================================================
func calcular_precio(nombre_pez: String) -> int:
	nombre_pez = nombre_pez.rstrip("0123456789")  # Limpia nombre numérico
	print("📛 DEBUG nombre_pez recibido:", nombre_pez)
	print("📦 DEBUG contenido Bitcoin_Pez:", BoxDatos.Bitcoin_Pez)
	for key in BoxDatos.Bitcoin_Pez.keys():
		if key in nombre_pez:
			var valor = BoxDatos.Bitcoin_Pez[key]
			print("✅ Precio detectado:", key, "→", valor)
			return valor
	print("⚠️ Nombre de pez no reconocido:", nombre_pez)
	return 10
