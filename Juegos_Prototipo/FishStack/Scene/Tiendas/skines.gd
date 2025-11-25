extends Control

# ================================
# 🔹 NODOS
# ================================
@onready var tiburon: Sprite2D = $Tiburon
@onready var seccion: GridContainer = $Seccion
@onready var label_info: Label = $LabelInfo
@onready var label_doblones: Label = $LabelDoblones
@onready var label_skin: Label = $LabelSkin
@onready var boton_salir: Button = $Salir
@onready var audio_efectos: AudioStreamPlayer = $AudioEfectos
@onready var voz_tiburon: AudioStreamPlayer = $VozTiburon
@onready var musica_tienda: AudioStreamPlayer = $AudioTienda   # ⭐ AÑADIR


# ================================
# 🔹 SPRITES DEL TIBURÓN
# ================================
@export var tiburon_normal: Texture2D
@export var tiburon_saludando: Texture2D

# ================================
# 🔹 SONIDOS
# ================================
@export var sonido_bienvenida: AudioStream
@export var sonido_compra: AudioStream
@export var sonido_error: AudioStream
@export var sonido_despedida: AudioStream

# ================================
# 🔹 POSICIONES / ROTACIONES
# ================================
@export var pos_normal := Vector2(330, 440)
@export var pos_saludo := Vector2(330, 420)

@export var rot_normal := 0.0
@export var rot_saludo := -6.0

# ================================
# 🔹 COLORES
# ================================
const COLOR_EQUIPADO := Color(0.3, 1.0, 0.3, 1.0)
const COLOR_COMPRADO := Color(1.0, 0.6, 0.4, 1.0)
const COLOR_NO_COMPRADO := Color.WHITE

# ==========================================================
# 🔹 READY
# ==========================================================
func _ready():
	# cargar datos
	Global.cargar_skins()
	
	# 🎵 MUSICA DE FONDO
	if not musica_tienda.playing:
		musica_tienda.stream.set_loop(true)
		musica_tienda.volume_db = -7
		musica_tienda.play()



	label_doblones.text = "💰 Doblones: %d" % Global.doblones
	label_skin.text = "Skin equipada: %s" % Global.skin_equipada

	_tiburon_anim("welcome")

	# LISTA REAL DE SKINS
	var skins = [
		{
			"nombre": "George",
			"precio": 0,
			"icono": preload("res://Assets/Skines/Skin0.png"),
			"descripcion": "El pescador original. Sin poderes, pero con estilo clásico."
		},
		{
			"nombre": "Privilegeado",
			"precio": 1500,
			"icono": preload("res://Assets/Skines/Skin1.png"),
			"descripcion": "Traje fino y actitud millonaria. Elegancia total."
		},
		{
			"nombre": "Verano",
			"precio": 2200,
			"icono": preload("res://Assets/Skines/Skin2.png"),
			"descripcion": "Listo para la playa. Ideal para pescar con calor."
		},
		{
			"nombre": "Eggman",
			"precio": 3000,
			"icono": preload("res://Assets/Skines/Skin3.png"),
			"descripcion": "Calvo, redondo y malvado. Un clásico villano."
		},
		{
			"nombre": "Gru",
			"precio": 4500,
			"icono": preload("res://Assets/Skines/Skin4.png"),
			"descripcion": "El jefe de los Minions. Pesca como un supervillano."
		},
		{
			"nombre": "Mafia",
			"precio": 4500,
			"icono": preload("res://Assets/Skines/Skin5.png"),
			"descripcion": "Elegante y peligroso. Pescarás como un verdadero capo."
		}
	]


	# inicializar botones
	for i in range(skins.size()):
		var data = skins[i]
		var boton := seccion.get_child(i)

		boton.texture_normal = data.icono
		boton.set_meta("nombre", data.nombre)
		boton.set_meta("precio", data.precio)
		boton.set_meta("descripcion", data.descripcion)


		boton.mouse_entered.connect(_hover_enter.bind(boton))
		boton.mouse_exited.connect(_hover_exit)
		boton.pressed.connect(func(): _comprar_o_equipar_skin(boton))

		# colores según estado
		if data.nombre == Global.skin_equipada:
			boton.modulate = COLOR_EQUIPADO
		elif data.nombre in Global.skins_comprados:
			boton.modulate = COLOR_COMPRADO
		else:
			boton.modulate = COLOR_NO_COMPRADO

	boton_salir.pressed.connect(_salir)
	label_info.visible = false

# ==========================================================
# 🔹 HOVER INFO
# ==========================================================
func _hover_enter(boton: TextureButton):
	label_info.visible = true
	label_info.text = "%s\n💰 %d\n📝 %s" % [
		boton.get_meta("nombre"),
		boton.get_meta("precio"),
		boton.get_meta("descripcion")
	]


func _hover_exit():
	label_info.visible = false

# ==========================================================
# 🔹 COMPRAR / EQUIPAR SKIN
# ==========================================================
func _comprar_o_equipar_skin(boton: TextureButton):
	var nombre = boton.get_meta("nombre")
	var precio = boton.get_meta("precio")
	

	# si ya está equipada → nada
	if nombre == Global.skin_equipada:
		return

	# comprar si no la tiene
	if not nombre in Global.skins_comprados:
		if Global.doblones < precio:
			_reproducir(sonido_error)
			return

		Global.doblones -= precio
		Global.skins_comprados.append(nombre)
		Global.guardar_skins()
		Global.guardar_doblones()

		label_doblones.text = "💰 Doblones: %d" % Global.doblones

		_reproducir(sonido_compra)
		_tiburon_anim("react")

	# equipar
	Global.skin_equipada = nombre
	Global.guardar_skins()

	label_skin.text = "Skin equipada: " + str(nombre)
	_actualizar_colores()

# ==========================================================
# 🔹 COLORES
# ==========================================================
func _actualizar_colores():
	for boton in seccion.get_children():
		var nombre = boton.get_meta("nombre")

		if nombre == Global.skin_equipada:
			boton.modulate = COLOR_EQUIPADO
		elif nombre in Global.skins_comprados:
			boton.modulate = COLOR_COMPRADO
		else:
			boton.modulate = COLOR_NO_COMPRADO

# ==========================================================
# 🔹 ANIMACIONES DEL TIBURÓN
# ==========================================================
func _tiburon_anim(tipo: String):
	match tipo:
		"welcome":
			tiburon.texture = tiburon_saludando
			tiburon.position = pos_saludo
			tiburon.rotation_degrees = rot_saludo
			_reproducir(sonido_bienvenida)
			await get_tree().create_timer(1.1).timeout
			_tiburon_normal()

		"react":
			tiburon.texture = tiburon_saludando
			tiburon.rotation_degrees = randf_range(-6, 6)
			tiburon.position = pos_saludo
			await get_tree().create_timer(0.7).timeout
			_tiburon_normal()

		"goodbye":
			tiburon.texture = tiburon_saludando
			tiburon.rotation_degrees = rot_saludo
			_reproducir(sonido_despedida)
			await get_tree().create_timer(1.2).timeout
			_tiburon_normal()

func _tiburon_normal():
	tiburon.texture = tiburon_normal
	tiburon.position = pos_normal
	tiburon.rotation_degrees = rot_normal

# ==========================================================
# 🔹 SALIR
# ==========================================================
func _salir():
	_tiburon_anim("goodbye")
	await get_tree().create_timer(1.2).timeout
	get_tree().change_scene_to_file("res://Scene/main_juego.tscn")

# ==========================================================
# 🔹 REPRODUCIR AUDIO
# ==========================================================
func _reproducir(s):
	audio_efectos.stream = s
	audio_efectos.play()
