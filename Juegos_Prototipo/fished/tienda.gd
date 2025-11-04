extends Control

# ================================
# NODOS PRINCIPALES
# ================================
@onready var tulio: Sprite2D = $Tulio
@onready var label_doblones: Label = $LabelDoblones
@onready var boton_salir: Button = $Salir
@onready var estanteria: GridContainer = $Estanteria
@onready var panel_info: Panel = $PanelInfo
@onready var musica_tienda: AudioStreamPlayer = $AudioTienda
@onready var audio_efectos: AudioStreamPlayer = $AudioEfectos

# ================================
# SONIDOS
# ================================
@export var sonido_bienvenida: AudioStream = preload("res://Assets/SFX/Welcome.mp3")
@export var sonido_compra: AudioStream = preload("res://Assets/SFX/Cachin.mp3")
@export var sonido_despedida: AudioStream = preload("res://Assets/SFX/Goodbye.mp3")
@export var musica_fondo: AudioStream = preload("res://Assets/Musicas/Cuphead OST - Porkrind's Shop [Music].mp3")

# ================================
# SPRITES DE TULIO
# ================================
@export var tulio_normal: Texture2D = preload("res://Assets/Tulio/Idle.png")
@export var tulio_habla: Texture2D = preload("res://Assets/Tulio/Welcome.png")
@export var tulio_despide: Texture2D = preload("res://Assets/Tulio/Goodbye.png")
@export var tulio_vende: Texture2D = preload("res://Assets/Tulio/Purchase.png")

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
		{"nombre": "Amuleto Raro", "precio": 2500, "efecto": "Reduce la penalizacion de pesca un -50% y velocidad del pescador +50%", "icono": preload("res://Assets/Amuletos/amuletoraro.png")},
		{"nombre": "Amuleto Celestial", "precio": 11600, "efecto": "Resiliencia -25% y Velocidad pasiva del barco 25%", "icono": preload("res://Assets/Amuletos/amuletocelestial.png")},
		{"nombre": "Amuleto Dineral", "precio": 5600, "efecto": "Ganancia X2 Cada pez que pesque tiene un 25% de dar 500 doblones", "icono": preload("res://Assets/Amuletos/amuletomasplata.png")},
		{"nombre": "Amuleto Secreto", "precio": 33600, "efecto": "Duplica la zona del jugador al pescar un pez, si es de noche 45% Suerte y 20% velocidad de progresion al pescar", "icono": preload("res://Assets/Amuletos/amuletosecreto.png")},
		{"nombre": "Amuleto Exotico", "precio": 3600, "efecto": "Reduce la velocidad de la barra del pez como la del jugador un 35% en el minijuego, Suerte +20%", "icono": preload("res://Assets/Amuletos/amuletoexotico.png")}
	]

	# Crear overlay de “✔️ comprado”
	var check_icon = load("res://Assets/Iconos/check.png")

	# Cargar botones
	for i in range(amuletos.size()):
		var data = amuletos[i]
		var boton = estanteria.get_child(i)

		if boton is TextureButton:
			boton.texture_normal = data.icono
			boton.set_meta("nombre", data.nombre)
			boton.set_meta("precio", data.precio)
			boton.set_meta("efecto", data.efecto)
			boton.set_meta("comprado", false)

			# Hover y click
			boton.mouse_entered.connect(_on_hover_entered.bind(boton))
			boton.mouse_exited.connect(_on_hover_exited)
			boton.pressed.connect(func(): _on_articulo_comprado(boton))

			# Si ya está comprado (array global)
			if data.nombre in Global.amuletos_comprados:
				_marcar_comprado(boton, check_icon)

	boton_salir.pressed.connect(_salir)
	panel_info.visible = false


# ================================
# COMPRAR ARTÍCULO
# ================================
func _on_articulo_comprado(boton: TextureButton):
	var nombre = boton.get_meta("nombre")
	var precio = boton.get_meta("precio")

	# Si ya está comprado
	if nombre in Global.amuletos_comprados:
		print("⚠️ Ya compraste este amuleto:", nombre)
		_reproducir_sonido(sonido_despedida)
		return

	if Global.doblones >= precio:
		Global.doblones -= precio
		Global.amuletos_comprados.append(nombre)
		label_doblones.text = "💰 Doblones: %d" % Global.doblones

		_tulio_hablar("react")
		_reproducir_sonido(sonido_compra)
		print("🛒 Comprado:", nombre, "| Nuevo saldo:", Global.doblones)

		# Mostrar ✔️ comprado
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
	boton.modulate = Color(0.6, 0.6, 0.6, 1)  # gris
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

	var main_scene = load("res://Scene/main_juego.tscn")
	if main_scene:
		get_tree().change_scene_to_packed(main_scene)
	else:
		push_error("❌ No se pudo cargar main_juego.tscn")


# ================================
# PANEL DE INFO
# ================================
func _on_hover_entered(boton: TextureButton):
	panel_info.visible = true
	var label_nombre = panel_info.get_node("VBoxContainer/LabelNombre")
	var label_precio = panel_info.get_node("VBoxContainer/LabelPrecio")
	var label_efecto = panel_info.get_node("VBoxContainer/LabelEfecto")

	label_nombre.text = boton.get_meta("nombre")
	label_precio.text = "💰 Precio: %d" % boton.get_meta("precio")
	label_efecto.text = "✨ " + boton.get_meta("efecto")

	# Ajuste dinámico: 2px por letra
	var cantidad_letras: int = label_efecto.text.length()
	var ancho_base: float = 250.0
	var px_por_letra: float = 2.0
	var ancho_maximo: float = 700.0
	var ancho_final: float = clamp(ancho_base + float(cantidad_letras) * px_por_letra, ancho_base, ancho_maximo)
	panel_info.custom_minimum_size.x = ancho_final

	await get_tree().process_frame
	var pos = boton.global_position + Vector2(60, -20)
	var viewport_size = get_viewport_rect().size
	var panel_size = panel_info.size
	panel_info.global_position = pos.clamp(Vector2(0, 0), viewport_size - panel_size)

func _on_hover_exited():
	panel_info.visible = false
