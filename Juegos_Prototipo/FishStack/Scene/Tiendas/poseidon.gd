extends Control

# ================================
# 🔹 NODOS
# ================================
@onready var label_doblones: Label = $LabelDoblones
@onready var boton_salir: Button = $Salir
@onready var estanteria: GridContainer = $Seccion

@onready var label_info: Label = $LabelInfo
@onready var label_nombre: Label = $LabelNombre
@onready var label_precio: Label = $LabelPrecio
@onready var label_equipado: Label = $LabelEquipado

@onready var musica_tienda: AudioStreamPlayer = $AudioTienda
@onready var audio_efectos: AudioStreamPlayer = $AudioEfectos
@onready var voz_poseidon: AudioStreamPlayer = $VozPoseidon

# ================================
# 🔹 CONFIG
# ================================
@export var musica_fondo: AudioStream
@export var sonido_compra: AudioStream
@export var sonido_equipar: AudioStream
@export var sonido_error: AudioStream

const COLOR_EQUIPADO := Color(0.3, 1.0, 0.3, 1)
const COLOR_NORMAL := Color.WHITE

# ================================
# 🔹 READY
# ================================
func _ready():

	# ---------- Música ----------
	if musica_fondo and not musica_tienda.playing:
		musica_tienda.stream = musica_fondo
		musica_tienda.stream.set_loop(true)
		musica_tienda.volume_db = -2
		musica_tienda.play()

	label_doblones.text = "💰 Doblones: %d" % Global.doblones
	label_info.visible = false
	label_equipado.visible = false

	# ---------- LISTA REAL ----------
	var items = [
		{
			"nombre": "Alineación Aqua",
			"precio": 50000,
			"descripcion": "duplica el spawn de peces mitologicos para arriba.
			Presiona el boton de HABILIDAD para que el anzuelo
			obtenga una luz azulada fuerte y triplique el spawn de peces celestiales y secretos por 30 segundos",
			"icono": preload("res://Assets/Alineaciones/Alineacion1.png")
		},
		{
			"nombre": "Alineación Sombría",
			"precio": 50000,
			"descripcion": "Pierde 25% de velocidad y gana 25% de velocidad.
			Presiona el boton de HABILIDAD para que entres en flujo invertido
			cuando pesques el siguiente pez el minijuego en vez de tener que mantener el pez en la barra tengas
			que evitarlo para pescarlo + 75% de velocidad de progresion
			en jefes solo hace que la penalizacion de velocidad de progresion se reduce la mitad
			el efecto dura hasta pescar 3 peces o al presionarse nuevamente HABILIDAD",
			"icono": preload("res://Assets/Alineaciones/Alineacion2.png")
		},
		{
			"nombre": "Alineación Infernal",
			"precio": 55000,
			"descripcion": "Tu barra de progresion en los minijuegos empieza en 40% cuando pescas cualquier pez, en caso de perder
			el minijuego tu anzuelo se vuelve al rojo vivo y limita como minimo a 10% la progresion por 5 segundos.
			Presiona el boton de HABILIDAD
			para que el anzuelo y el pescador entren en llamas duplicando su :
			velocidad de recogida del anzuelo, velocidad del pescador, fuerza de tiro 
			 velocidad vertical y resistencia al agua por 15 segundos",
			"icono": preload("res://Assets/Alineaciones/Alineacion3.png")
		}
	]

	for i in range(items.size()):
		var data = items[i]
		var boton = estanteria.get_child(i)

		if boton is TextureButton:
			boton.texture_normal = data.icono
			boton.set_meta("nombre", data.nombre)
			boton.set_meta("precio", data.precio)
			boton.set_meta("descripcion", data.descripcion)

			boton.mouse_entered.connect(_hover_enter.bind(boton))
			boton.mouse_exited.connect(_hover_exit)
			boton.pressed.connect(func(): _equipar_alineacion(boton))

			# estado visual
			if data.nombre == Global.alineacion_equipada:
				boton.modulate = COLOR_EQUIPADO
			else:
				boton.modulate = COLOR_NORMAL

	# Salida
	boton_salir.pressed.connect(_salir)


# ================================
# 🔹 HOVER
# ================================
func _hover_enter(boton: TextureButton):
	label_info.visible = true
	label_nombre.text = boton.get_meta("nombre")
	label_precio.text = "💰 " + str(boton.get_meta("precio"))
	label_info.text = boton.get_meta("descripcion")

	# Mostrar si está equipado
	label_equipado.visible = (boton.get_meta("nombre") == Global.alineacion_equipada)

func _hover_exit():
	label_info.visible = false
	label_equipado.visible = false
	label_nombre.text = ""
	label_precio.text = ""


# ================================
# 🔹 EQUIPAR / COMPRAR
# ================================
func _equipar_alineacion(boton: TextureButton):
	var nombre = boton.get_meta("nombre")
	var precio = boton.get_meta("precio")

	# -------- YA EQUIPADO --------
	if nombre == Global.alineacion_equipada:
		print("✔ Ya equipada:", nombre)
		return

	# -------- SI NO ESTÁ COMPRADA → COMPRAR --------
	if not nombre in Global.alineaciones_compradas:

		if Global.doblones < precio:
			print("❌ No tienes suficiente dinero.")
			_reproducir_sonido(sonido_error)
			return

		# Comprar
		Global.doblones -= precio
		Global.alineaciones_compradas.append(nombre)
		Global.guardar_poseidon()

		label_doblones.text = "💰 Doblones: %d" % Global.doblones
		_reproducir_sonido(sonido_compra)


	# -------- EQUIPAR --------
	Global.alineacion_equipada = nombre
	Global.guardar_poseidon()
	_reproducir_sonido(sonido_equipar)

	_actualizar_colores()


func _actualizar_colores():
	for boton in estanteria.get_children():
		if not (boton is TextureButton):
			continue

		var nombre = boton.get_meta("nombre")

		if nombre == Global.alineacion_equipada:
			boton.modulate = COLOR_EQUIPADO
		else:
			boton.modulate = COLOR_NORMAL


# ================================
# 🔹 Sonidos
# ================================
func _reproducir_sonido(s):
	if audio_efectos and s:
		audio_efectos.stream = s
		audio_efectos.play()


# ================================
# 🔹 SALIR
# ================================
func _salir():
	_reproducir_sonido(sonido_equipar)
	await get_tree().create_timer(0.8).timeout
	get_tree().change_scene_to_file("res://Scene/main_juego.tscn")
