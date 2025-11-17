extends Control

# ================================
# 🔹 NODOS PRINCIPALES
# ================================
@onready var chino: Sprite2D = $Chino
@onready var label_doblones: Label = $LabelDoblones
@onready var boton_salir: Button = $Salir
@onready var estanteria: GridContainer = $Seccion
@onready var musica_tienda: AudioStreamPlayer = $AudioTienda
@onready var audio_efectos: AudioStreamPlayer = $AudioEfectos
@onready var label_info: Label = $LabelInfo
@onready var label_barco: Label = $LabelBarco

# ================================
# 🔹 SONIDOS (EDITABLES)
# ================================
@export var sonido_bienvenida: AudioStream
@export var sonido_compra: AudioStream
@export var sonido_despedida: AudioStream
@export var musica_fondo: AudioStream

# ================================
# 🔹 SPRITES DEL CHINO (EDITABLES)
# ================================
@export var chino_normal: Texture2D
@export var chino_habla: Texture2D
@export var chino_despide: Texture2D
@export var chino_vende: Texture2D

# ================================
# 🔹 POSICIONES / ROTACIONES (EDITABLES)
# ================================
@export var pos_normal := Vector2(270, 450)
@export var rot_normal := 0.0

@export var pos_bienvenida := Vector2(270, 420)
@export var rot_bienvenida := -4.0

@export var pos_despedida := Vector2(270, 440)
@export var rot_despedida := 4.0

@export var pos_reaccion := Vector2(270, 440)
@export var rot_reaccion_rango := 4.0

const COLOR_EQUIPADO := Color(0.3, 1.0, 0.3, 1)
const COLOR_DESEQUIPADO := Color(1.0, 0.4, 0.4, 1)
const COLOR_COMPRADO := Color(0.6, 0.6, 0.6, 1)

# ================================
# 🔹 READY
# ================================
func _ready():
	Global.cargar_barcos()
	Global.cargar_barco_equipado()
	_actualizar_label_barco()

	# Música
	if musica_fondo and not musica_tienda.playing:
		musica_tienda.stream = musica_fondo
		musica_tienda.stream.set_loop(true)
		musica_tienda.volume_db = -2
		musica_tienda.play()

	label_doblones.text = "💰 Doblones: %d" % Global.doblones

	_chino_hablar("welcome")
	_reproducir_sonido(sonido_bienvenida)

	# ============================
	# LISTA DE BARCOS
	# ============================
	var barcos = [
		{
			"nombre": "Bote Chico",
			"precio": 10,
			"efecto": "Sin efectos - Bote Inicial",
			"icono": preload("res://Assets/Barcos/barcoT1.png")
		},
		{
			"nombre": "Velero Rojo",
			"precio": 3500,
			"efecto": "+20% velocidad del pescador",
			"icono": preload("res://Assets/Barcos/barcoT2.png")
		},
		{
			"nombre": "Lancha Veloz",
			"precio": 5200,
			"efecto": "+40% velocidad del pescador y 25% de reduccion a la penalizacion de pesca",
			"icono": preload("res://Assets/Barcos/barcoT3.png")
		},
		{
			"nombre": "Barco Pesquero",
			"precio": 8800,
			"efecto": "+60% velocidad, +10% de ganancias y 55% de reduccion a la penalizacion de pesca",
			"icono": preload("res://Assets/Barcos/barcoT4.png")
		},
		{
			"nombre": "Buque Marino",
			"precio": 14500,
			"efecto": "+85% velocidad, +25% de ganancias y 25% de reduccion a la penalizacion de pesca",
			"icono": preload("res://Assets/Barcos/barcoT5.png")
		}
	]

	# ✔ icono de comprado
	var check_icon = load("res://Assets/Iconos/check.png")

	for i in range(barcos.size()):
		var data = barcos[i]
		var boton = estanteria.get_child(i)

		if boton is TextureButton:
			boton.texture_normal = data.icono
			boton.set_meta("nombre", data.nombre)
			boton.set_meta("precio", data.precio)
			boton.set_meta("efecto", data.efecto)

			boton.mouse_entered.connect(_hover_enter.bind(boton))
			boton.mouse_exited.connect(_hover_exit)
			boton.pressed.connect(func(): _comprar_o_equipar_barco(boton))

			# ============================
			# ESTADO VISUAL DEL BOTÓN
			# ============================
			if data.nombre == Global.barco_equipado:
				# 🟢 EQUIPADO
				boton.modulate = COLOR_EQUIPADO

			elif data.nombre in Global.barcos_comprados:
				# 🔴 COMPRADO PERO NO EQUIPADO
				boton.modulate = COLOR_DESEQUIPADO

			else:
				# ⚪ NO COMPRADO
				boton.modulate = Color.WHITE

	boton_salir.pressed.connect(_salir)
	label_info.visible = false

# ================================
# 🔹 HOVER INFO
# ================================
func _hover_enter(boton: TextureButton):
	label_info.visible = true
	label_info.text = "%s\n💰 %d\n✨ %s" % [
		boton.get_meta("nombre"),
		boton.get_meta("precio"),
		boton.get_meta("efecto")
	]

func _hover_exit():
	label_info.visible = false
	
func _actualizar_label_barco():
	if label_barco:
		label_barco.text = "Barco equipado: " + str(Global.barco_equipado)

	# ================================
# 🔹 COMPRAR O EQUIPAR BARCO
# ================================
func _comprar_o_equipar_barco(boton: TextureButton):
	var nombre = boton.get_meta("nombre")
	var precio = boton.get_meta("precio")

	# 1) YA EQUIPADO
	if nombre == Global.barco_equipado:
		print("✔ Ya equipado:", nombre)
		return

	# 2) SI NO ESTÁ COMPRADO → COMPRAR
	if not nombre in Global.barcos_comprados:
		if Global.doblones < precio:
			print("❌ Dinero insuficiente para", nombre)
			_reproducir_sonido(sonido_despedida)
			return

		Global.doblones -= precio
		Global.barcos_comprados.append(nombre)
		Global.guardar_barcos()

		label_doblones.text = "💰 Doblones: %d" % Global.doblones
		_reproducir_sonido(sonido_compra)
		_chino_hablar("react")

	# 3) EQUIPAR BARCO
	Global.barco_equipado = nombre
	Global.guardar_barco_equipado()
	_actualizar_label_barco()

	# 4) ACTUALIZAR COLORES
	_actualizar_colores_barcos()

	print("🚤 Barco equipado:", nombre)

# ================================
# 🔹 ACTUALIZAR COLORES
# ================================
func _actualizar_colores_barcos():
	for boton in estanteria.get_children():
		if not (boton is TextureButton):
			continue

		var nombre = boton.get_meta("nombre")

		if nombre == Global.barco_equipado:
			boton.modulate = COLOR_EQUIPADO
		elif nombre in Global.barcos_comprados:
			boton.modulate = COLOR_DESEQUIPADO
		else:
			boton.modulate = Color.WHITE

# ================================
# 🔹 SONIDOS
# ================================
func _reproducir_sonido(s: AudioStream):
	if audio_efectos:
		audio_efectos.stream = s
		audio_efectos.play()

# ================================
# 🔹 CHINO ANIMACIONES
# ================================
func _chino_hablar(tipo: String):
	match tipo:
		"welcome":
			chino.texture = chino_habla
			chino.rotation_degrees = rot_bienvenida
			chino.position = pos_bienvenida
			await get_tree().create_timer(1.3).timeout
			_chino_normal()
		"react":
			chino.texture = chino_vende
			chino.rotation_degrees = randf_range(-rot_reaccion_rango, rot_reaccion_rango)
			chino.position = pos_reaccion
			await get_tree().create_timer(0.8).timeout
			_chino_normal()
		"goodbye":
			chino.texture = chino_despide
			chino.rotation_degrees = rot_despedida
			chino.position = pos_despedida
			await get_tree().create_timer(1.2).timeout
			_chino_normal()

func _chino_normal():
	chino.texture = chino_normal
	chino.rotation_degrees = rot_normal
	chino.position = pos_normal

# ================================
# 🔹 SALIR
# ================================
func _salir():
	_chino_hablar("goodbye")
	_reproducir_sonido(sonido_despedida)
	await get_tree().create_timer(1.4).timeout
	Global.guardar_barcos()
	get_tree().change_scene_to_file("res://Scene/main_juego.tscn")
