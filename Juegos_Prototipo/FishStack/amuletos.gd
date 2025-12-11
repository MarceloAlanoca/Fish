extends Control

# ================================
# NODOS PRINCIPALES
# ================================
@onready var tulio: Sprite2D = $Tulio
@onready var label_doblones: Label = $LabelDoblones
@onready var boton_salir: Button = $Salir
@onready var estanteria: CanvasLayer = $CanvasLayer
@onready var musica_tienda: AudioStreamPlayer = $AudioTienda
@onready var audio_efectos: AudioStreamPlayer = $AudioEfectos
@onready var label_nombreinfo: Label = $CanvasLayer/LabelInfo # ✅ único label de info

# ================================
# SONIDOS
# ================================
@export var sonido_bienvenida: AudioStream = preload("res://Assets/SFX/Welcome.ogg")
@export var sonido_compra: AudioStream = preload("res://Assets/SFX/Cachin.ogg")
@export var sonido_despedida: AudioStream = preload("res://Assets/SFX/Goodbye.ogg")
@export var musica_fondo: AudioStream = preload("res://Assets/Musicas/Cuphead OST - Porkrind's Shop [Music].mp3")

# ================================
# SPRITES DE TULIO
# ================================
@export var tulio_normal: Texture2D = preload("res://Assets/Vendedores/Tulio/Idle.png")
@export var tulio_habla: Texture2D = preload("res://Assets/Vendedores/Tulio/Welcome.png")
@export var tulio_despide: Texture2D = preload("res://Assets/Vendedores/Tulio/Goodbye.png")
@export var tulio_vende: Texture2D = preload("res://Assets/Vendedores/Tulio/Purchase.png")

# ================================
# POSICIONES / ROTACIONES
# ================================
@export var pos_normal := Vector2(1100, 450)
@export var rot_normal := 0.0
@export var pos_bienvenida := Vector2(1100, 420)
@export var rot_bienvenida := -5.0
@export var pos_despedida := Vector2(1080, 440)
@export var rot_despedida := 5.0
@export var pos_reaccion := Vector2(1110, 440)
@export var rot_reaccion_rango := 3.0

# ================================
# READY
# ================================
func _ready():
	Global.cargar_amuletos()

	# 🎵 Música de fondo
	if musica_tienda and not musica_tienda.playing:
		musica_tienda.stream = musica_fondo
		musica_tienda.stream.set_loop(true)
		musica_tienda.volume_db = 0
		musica_tienda.play()

	label_doblones.text = "💰 Doblones: %d" % Global.doblones
	_tulio_hablar("welcome")
	_reproducir_sonido(sonido_bienvenida)

	# Lista de amuletos
	var amuletos = [
		{"nombre": "Amuleto Común", "precio": 1000, "efecto": "Reduce la resiliencia general un -10%", "icono": preload("res://Assets/Amuletos/amuletocomun.png")},
		{"nombre": "Amuleto Raro", "precio": 2500, "efecto": "Reduce la penalización de pesca un -50% y velocidad del pescador +50%", "icono": preload("res://Assets/Amuletos/amuletoraro.png")},
		{"nombre": "Amuleto Celestial", "precio": 11600, "efecto": "Resiliencia -25% y velocidad pasiva del barco +25%", "icono": preload("res://Assets/Amuletos/amuletocelestial.png")},
		{"nombre": "Amuleto Dineral", "precio": 5600, "efecto": "Ganancia x1.45. Cada pez puede dar 500 doblones extra (25%)", "icono": preload("res://Assets/Amuletos/amuletomasplata.png")},
		{"nombre": "Amuleto Secreto", "precio": 33600, "efecto": "Duplica la zona al pescar, 45% suerte de noche, 20% velocidad de progresión", "icono": preload("res://Assets/Amuletos/amuletosecreto.png")},
		{"nombre": "Amuleto Exótico", "precio": 3600, "efecto": "Reduce la velocidad del pez y jugador un 35%, suerte +20%", "icono": preload("res://Assets/Amuletos/amuletoexotico.png")}
	]

	# Crear overlay de “✔️ comprado”
	var check_icon = load("res://Assets/Iconos/check.png")

	for i in range(amuletos.size()):
		var data = amuletos[i]
		var boton = estanteria.get_child(i)

		if boton is TextureButton:
			boton.texture_normal = data.icono
			boton.set_meta("nombre", data.nombre)
			boton.set_meta("precio", data.precio)
			boton.set_meta("efecto", data.efecto)
			boton.set_meta("comprado", false)

			boton.mouse_entered.connect(_on_hover_entered.bind(boton))
			boton.mouse_exited.connect(_on_hover_exited)
			boton.pressed.connect(func(): _on_articulo_comprado(boton))

			if data.nombre in Global.amuletos_comprados:
				_marcar_comprado(boton, check_icon)

	boton_salir.pressed.connect(_salir)
	label_nombreinfo.visible = false # 🔹 oculto al inicio

# ================================
# COMPRAR ARTÍCULO
# ================================
func _on_articulo_comprado(boton: TextureButton):
	var nombre = boton.get_meta("nombre")
	var precio = boton.get_meta("precio")

	if nombre in Global.amuletos_comprados:
		print("⚠️ Ya compraste este amuleto:", nombre)
		_reproducir_sonido(sonido_despedida)
		return

	if Global.doblones >= precio:
		Global.doblones -= precio
		Global.amuletos_comprados.append(nombre)
		Global.guardar_amuletos()
		label_doblones.text = "💰 Doblones: %d" % Global.doblones
		Global.guardar_doblones()

		_tulio_hablar("react")
		_reproducir_sonido(sonido_compra)
		print("🛒 Comprado:", nombre, "| Nuevo saldo:", Global.doblones)

		var check_icon = preload("res://Assets/Iconos/check.png") if ResourceLoader.exists("res://Assets/Iconos/check.png") else null
		_marcar_comprado(boton, check_icon)
	else:
		print("❌ No tienes suficientes doblones para", nombre)
		_reproducir_sonido(sonido_despedida)

# ================================
# MARCAR AMULETO COMO COMPRADO
# ================================
func _marcar_comprado(boton: TextureButton, check_icon):
	boton.disabled = true
	boton.modulate = Color(0.6, 0.6, 0.6, 1)
	if check_icon:
		var icon = TextureRect.new()
		icon.texture = check_icon
		icon.expand_mode = TextureRect.EXPAND_FIT_WIDTH
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		icon.size_flags_vertical = Control.SIZE_EXPAND_FILL
		boton.add_child(icon)
	boton.set_meta("comprado", true)

# ================================
# SONIDOS
# ================================
func _reproducir_sonido(stream: AudioStream):
	if audio_efectos:
		audio_efectos.stream = stream
		audio_efectos.play()

# ================================
# TULIO
# ================================
func _tulio_hablar(tipo: String):
	match tipo:
		"welcome":
			tulio.texture = tulio_habla
			tulio.rotation_degrees = rot_bienvenida
			tulio.position = pos_bienvenida
			await get_tree().create_timer(1.5).timeout
			_tulio_volver_normal()
		"goodbye":
			tulio.texture = tulio_despide
			tulio.rotation_degrees = rot_despedida
			tulio.position = pos_despedida
			await get_tree().create_timer(1.2).timeout
			_tulio_volver_normal()
		"react":
			tulio.texture = tulio_vende
			tulio.rotation_degrees = randf_range(-rot_reaccion_rango, rot_reaccion_rango)
			tulio.position = pos_reaccion
			await get_tree().create_timer(0.8).timeout
			_tulio_volver_normal()

func _tulio_volver_normal():
	tulio.texture = tulio_normal
	tulio.rotation_degrees = rot_normal
	tulio.position = pos_normal

# ================================
# SALIR DE LA TIENDA
# ================================
func _salir():
	_tulio_hablar("goodbye")
	_reproducir_sonido(sonido_despedida)
	await get_tree().create_timer(1.5).timeout
	Global.guardar_amuletos()
	var main_scene = load("res://Scene/main_juego.tscn")
	if main_scene:
		get_tree().change_scene_to_packed(main_scene)
	else:
		push_error("❌ No se pudo cargar main_juego.tscn")

# ================================
# INFORMACIÓN (solo LabelInfo)
# ================================
func _on_hover_entered(boton: TextureButton):
	label_nombreinfo.visible = true
	label_nombreinfo.text = "%s\n💰 Precio: %d\n✨ %s" % [
		boton.get_meta("nombre"),
		boton.get_meta("precio"),
		boton.get_meta("efecto")
	]

func _on_hover_exited():
	label_nombreinfo.visible = false
