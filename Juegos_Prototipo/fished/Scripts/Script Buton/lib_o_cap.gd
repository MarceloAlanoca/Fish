extends Control
class_name LibOCap

@onready var panel := $"."                     # Panel contenedor
@onready var boton_liberar := $VBoxContainer/Liberar
@onready var boton_vender := $VBoxContainer/Capturar
@onready var interfaz := $"../InterfazUsuario" # Referencia a la UI global si está en escena

var pez_actual: Node = null
var anzuelo: Node = null

# Cargamos datos de precios desde FishBox
var Box = load("res://Scripts/FishBox.gd")
var BoxDatos = Box.new()


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
func mostrar_panel(pez: Node) -> void:
	pez_actual = pez
	panel.visible = true
	print("📋 Mostrando panel de venta para:", pez.name)


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
		if anzuelo:
			anzuelo.liberar_pez()

		var valor = Global.aplicar_efectos_ganancia(calcular_precio(pez_actual.name))
		Global.doblones += valor   # 💸 Sumamos al dinero global

		print("💰 Pez vendido:", pez_actual.name, "Valor:", valor, "Total global:", Global.doblones)

		# 🔄 Actualizar el HUD si existe
		if interfaz:
			interfaz.actualizar_label()

	panel.visible = false
	pez_actual = null


# ========================================================
# 💲 Obtener precio desde FishBox
# ========================================================
func calcular_precio(nombre_pez: String) -> int:
	match nombre_pez:
		"Atun": return BoxDatos.Bitcoin_Pez.BitAtun
		"Salmon": return BoxDatos.Bitcoin_Pez.BitSalmon
		"Orca": return BoxDatos.Bitcoin_Pez.BitOrca
		"Barracuda": return BoxDatos.Bitcoin_Pez.BitBarracuda
		"Lenguado": return BoxDatos.Bitcoin_Pez.BitLenguado
		"Payaso": return BoxDatos.Bitcoin_Pez.BitPayaso
		"Ballena": return BoxDatos.Bitcoin_Pez.BitBallena
		_: return 10
