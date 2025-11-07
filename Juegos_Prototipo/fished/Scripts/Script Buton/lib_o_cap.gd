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

	# ✅ Limpia el nombre (quita espacios y números)
	var nombre_final = nombre_real if nombre_real != "" else pez_actual.name
	nombre_final = nombre_final.strip_edges()
	nombre_final = nombre_final.rstrip("0123456789")

	var valor = calcular_precio(nombre_final)

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

	# ✅ Cargar imagen del pez (si existe)
	var ruta = "res://Assets/Peces/%s.png" % nombre_final
	print("🔎 Buscando imagen en:", ruta)

	if ResourceLoader.exists(ruta):
		var textura = load(ruta)
		pez_preview.texture = textura
		print("🖼️ Imagen mostrada para:", nombre_final)
		
	else:
		pez_preview.texture = null
		print("🚫 Imagen no encontrada para:", nombre_final, "→", ruta)

	pez_preview.visible = pez_preview.texture != null

	print("📋 Mostrando panel de venta para:", nombre_final)



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
