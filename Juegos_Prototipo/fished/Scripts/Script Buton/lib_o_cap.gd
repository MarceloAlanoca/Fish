#extends Control
#class_name LibOCap

#@onready var panel := $"."  # tu panel principal
#@onready var boton_liberar := $VBoxContainer/Liberar
#@onready var boton_guardar := $VBoxContainer/Capturar
#@onready var inventory_ui := get_node("/root/MainJuego/CanvasLayer/InventoryUI")  # Ajustar ruta

#var pez_actual: Node = null
#var anzuelo: Node = null

#func _ready() -> void:
	#panel.visible = false

	# Buscamos el anzuelo en grupo
	#var anzuelos = get_tree().get_nodes_in_group("anzuelo")
	#if anzuelos.size() > 0:
		#anzuelo = anzuelos[0]
	#else:
		#push_warning("⚠️ No se encontró el anzuelo en grupo 'anzuelo'")

	#boton_liberar.pressed.connect(_on_liberar_pressed)
	#boton_guardar.pressed.connect(_on_guardar_pressed)

# Mostrar panel al volver el anzuelo
#func mostrar_panel(pez: Node) -> void:
	#pez_actual = pez
	#panel.visible = true
	#print("📋 Mostrando panel LibOCap para:", pez.name)

# -------------------------
# Botón Liberar
# -------------------------
#func _on_liberar_pressed() -> void:
	#if anzuelo:
		#anzuelo.liberar_pez()
	#panel.visible = false
	#print("🐠 Pez liberado")

# -------------------------
# Botón Guardar
# -------------------------
#func _on_guardar_pressed() -> void:
	#if anzuelo and pez_actual:
		# Agregar al inventario
		#_agregar_al_inventario(pez_actual)
		#anzuelo.guardar_pez()
	#panel.visible = false
	#print("🎁 Pez guardado")

# -------------------------
# Función para guardar el sprite en el slot
# -------------------------
#func _agregar_al_inventario(pez: Node) -> void:
	#if not inventory_ui:
		#push_warning("⚠️ InventoryUI no asignado")
		#return

	# Tomamos el sprite original del pez
	#var sprite_pez = pez.get_node_or_null("Sprite2D")
	#if not sprite_pez:
		#sprite_pez = pez.get_node_or_null("AnimatedSprite2D")
	#if not sprite_pez:
		#push_warning("⚠️ No se encontró sprite del pez")
		#return

	# Buscamos el primer slot vacío (adaptar según tu inventario)
	#for slot in inventory_ui.get_children():
		#if slot.get_child_count() == 0:
			#var copia_sprite = Sprite2D.new()
			#copia_sprite.texture = sprite_pez.texture
			#copia_sprite.scale = Vector2(0.5, 0.5)  # Ajustar tamaño al slot
			#slot.add_child(copia_sprite)
			#print("✅ Pez guardado en inventario:", pez.name)
			#return

	#print("⚠️ No hay slots libres en el inventario")

extends Control
class_name LibOCap

@onready var panel := $"."
@onready var boton_liberar := $VBoxContainer/Liberar
@onready var boton_vender := $VBoxContainer/Capturar

var pez_actual: Node = null
var anzuelo: Node = null
var dinero: int = 0  # Dinero acumulado

# Cargamos FishBox
var Box = load("res://Scripts/FishBox.gd")  # Ajustá la ruta
var BoxDatos = Box.new()

func _ready() -> void:
	panel.visible = false
	# Buscamos el anzuelo en la escena
	var anzuelos = get_tree().get_nodes_in_group("anzuelo")
	if anzuelos.size() > 0:
		anzuelo = anzuelos[0]
	else:
		push_warning("⚠️ No se encontró el anzuelo en grupo 'anzuelo'")
	
	boton_liberar.pressed.connect(_on_liberar_pressed)
	boton_vender.pressed.connect(_on_vender_pressed)

# Llamado desde el anzuelo cuando vuelve a su posición
func mostrar_panel(pez: Node) -> void:
	pez_actual = pez
	panel.visible = true
	print("📋 Mostrando panel de venta para:", pez.name)

func _on_liberar_pressed() -> void:
	if anzuelo:
		anzuelo.liberar_pez()
	panel.visible = false
	print("🐠 Pez liberado")

func _on_vender_pressed() -> void:
	if pez_actual:
		if anzuelo:
			anzuelo.liberar_pez()
		var valor = calcular_precio(pez_actual.name)
		
		panel.visible = false
		dinero += valor
		print("💰 Pez vendido:", pez_actual.name, "Valor:", valor, "Dinero total:", dinero)
	panel.visible = false
	pez_actual = null
	
	if $"../InterfazUsuario":
		$"../InterfazUsuario".actualizar_dinero(dinero)
	

# Función para obtener precio desde Bitcoin_Pez
func calcular_precio(nombre_pez: String) -> int:
	match nombre_pez:
		"Atun":
			return BoxDatos.Bitcoin_Pez.BitAtun
		"Salmon":
			return BoxDatos.Bitcoin_Pez.BitSalmon
		"Orca":
			return BoxDatos.Bitcoin_Pez.BitOrca
		"Barracuda":
			return BoxDatos.Bitcoin_Pez.BitBarracuda
		"Lenguado":
			return BoxDatos.Bitcoin_Pez.BitLenguado
		"Payaso":
			return BoxDatos.Bitcoin_Pez.BitPayaso
		"Ballena":
			return BoxDatos.Bitcoin_Pez.BitBallena
		_:
			return 10

@onready var ui := get_tree().current_scene.get_node_or_null("InterfazUsuario")
