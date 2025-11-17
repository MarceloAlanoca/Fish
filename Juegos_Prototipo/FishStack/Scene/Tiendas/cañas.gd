extends Control

# ================================
# 🔹 NODOS PRINCIPALES
# ================================
@onready var salesman: Sprite2D = $Salesman
@onready var label_doblones: Label = $LabelDoblones
@onready var boton_salir: Button = $Salir
@onready var estanteria: GridContainer = $Seccion
@onready var musica_tienda: AudioStreamPlayer = $AudioTienda
@onready var audio_efectos: AudioStreamPlayer = $AudioEfectos
@onready var voz_salesman: AudioStreamPlayer = $VozSalesman
@onready var subtitulos: Label = $LabelSubtitulos
@onready var label_info: Label = $LabelInfo  # 👈 agregado para hover info

# ================================
# 🔹 CONFIGURACIONES EXPORTADAS
# ================================
@export var musica_fondo: AudioStream
@export var sonido_compra: AudioStream
@export var sonido_despedida: AudioStream
@export var sonido_error: AudioStream        # 👈 nuevo: para error o falta de dinero
@export var sonido_voz: AudioStream          # murmullo del vendedor

# ================================
# 🔹 SPRITES DEL VENDEDOR
# ================================
@export var salesman_normal: Texture2D
@export var salesman_habla: Texture2D
@export var salesman_vende: Texture2D
@export var salesman_despide: Texture2D

# ================================
# 🔹 POSICIONES / ROTACIONES
# ================================
@export var pos_normal := Vector2(1100, 450)
@export var rot_normal := 0.0
@export var pos_habla := Vector2(1100, 420)
@export var rot_habla := -3.0

# ================================
# 🔹 FRASES CONFIGURABLES
# ================================
@export var frases_idle: Array[String] = [
	"¿Has probado lanzar una caña bajo la lluvia?",
	"Las cañas también sueñan, ¿sabías?",
	"Hay hilos que pescan más que las redes.",
	"Algunos peces son más curiosos que los humanos..."
]

@export var frases_compra: Array[String] = [
	"Excelente elección, pescador.",
	"Esta caña resistirá las mareas del destino.",
	"No todos pueden pagar una joya así.",
	"Con esto, los peces no tendrán escapatoria."
]

@export var frases_despedida: Array[String] = [
	"La corriente siempre vuelve.",
	"Que las aguas te sean favorables.",
	"No olvides afilar tu instinto.",
	"Nos veremos bajo otra marea."
]

@export var frases_error: Array[String] = [
	"No tienes suficientes doblones, vuelve más tarde.",
	"Esa caña ya sera tuya, no insistas.",
	"Ni los tiburones pescan sin monedas.",
	"Tu bolsillo parece vacío..."
]

# ================================
# 🔹 CONFIGURACIÓN DE TIEMPO
# ================================
@export var tiempo_frase_idle: float = 30.0
var tiempo_acumulado := 0.0
var hablando := false

# ================================
# 🔹 READY
# ================================
func _ready():
	Global.cargar_cañas()

	# 🎵 Música de fondo
	if musica_fondo:
		musica_tienda.stop()
		musica_tienda.stream = musica_fondo.duplicate()
		if musica_tienda.stream is AudioStreamOggVorbis:
			musica_tienda.stream.loop = true
		musica_tienda.volume_db = -3.0
		musica_tienda.play()
		fade_audio(musica_tienda, -3.0, 1.5) # Fade in suave
	else:
		push_warning("🎵 No se asignó música de fondo en el inspector.")

	label_doblones.text = "💰 Doblones: %d" % Global.doblones
	subtitulos.text = ""
	label_info.visible = false

	# 🎣 Crear cañas
	var cañas = [
		{
			"nombre": "Caña de Madera",
			"precio": 10,
			"efecto": "-Caña inicial y sin beneficios, con un buen tiro capaz logras romper ese mero limite",
			"profundidad": "Superficial - 150m",
			"icono": preload("res://Assets/Cañas/cañaT1.png")
		},
		{
			"nombre": "Caña de Mango Grande",
			"precio": 2400,
			"efecto": "Aumenta en un 20% la Velocidad de recogida",
			"profundidad": "Aguas poco Profundas - 1000m",
			"icono": preload("res://Assets/Cañas/cañaT2.png")
		},
		{
			"nombre": "Caña de Acero",
			"precio": 6400,
			"efecto": "Aumenta la velocidad de recogida, subida y bajada (vertical) del anzuelo un 45%.",
			"profundidad": "Agua profundas - 3500m",
			"icono": preload("res://Assets/Cañas/cañaT3.png")
		},
		{
			"nombre": "Caña Épica",
			"precio": 14800,
			"efecto": "25%- de resilencia y 50%+ de velocidad de anzuelo vertical",
			"profundidad": "Abisal - 6000m",
			"icono": preload("res://Assets/Cañas/cañaT4.png")
		},
		{
			"nombre": "Caña Legendaria",
			"precio": 24000,
			"efecto": "Relantiza la barra de carga al lanzar la caña un 25%, Velocidad +65% a todo el anzuelo (Recogida y vertical) y -30% resiliencia al pescar.",
			"profundidad": "Hadal - 10000m",
			"icono": preload("res://Assets/Cañas/cañaT5.png")
		}
	]

	for i in range(cañas.size()):
		var data = cañas[i]
		var boton = estanteria.get_child(i)
		if boton is TextureButton:
			boton.texture_normal = data.icono
			boton.set_meta("nombre", data.nombre)
			boton.set_meta("precio", data.precio)
			boton.set_meta("profundidad", data.profundidad)
			boton.set_meta("efecto", data.efecto)

			boton.mouse_entered.connect(_on_hover_entered.bind(boton))
			boton.mouse_exited.connect(_on_hover_exited)
			boton.pressed.connect(func(): _comprar_caña(boton))

			if data.nombre in Global.cañas_compradas:
				_marcar_comprado(boton)

	boton_salir.pressed.connect(_salir)

# ================================
# 🔹 LOOP AUTOMÁTICO DE FRASES
# ================================
func _process(delta):
	tiempo_acumulado += delta
	if tiempo_acumulado >= tiempo_frase_idle and not hablando:
		tiempo_acumulado = 0
		_hablar(frases_idle.pick_random())

# ================================
# 🔹 HOVER INFO
# ================================
func _on_hover_entered(boton: TextureButton):
	label_info.visible = true
	label_info.text = "%s\n💰 Precio: %d\n🌊 %s\n✨ %s" % [
		boton.get_meta("nombre"),
		boton.get_meta("precio"),
		boton.get_meta("profundidad"),
		boton.get_meta("efecto")
	]


func _on_hover_exited():
	label_info.visible = false

# ================================
# 🔹 COMPRA DE CAÑA
# ================================
func _comprar_caña(boton: TextureButton):
	var nombre = boton.get_meta("nombre")
	var precio = boton.get_meta("precio")

	if nombre in Global.cañas_compradas:
		audio_efectos.stream = sonido_error
		audio_efectos.play()
		_hablar(frases_error.pick_random())
		return

	if Global.doblones >= precio:
		Global.doblones -= precio
		Global.cañas_compradas.append(nombre)
		Global.guardar_cañas()
		label_doblones.text = "💰 Doblones: %d" % Global.doblones

		_marcar_comprado(boton)
		audio_efectos.stream = sonido_compra
		audio_efectos.play()
		_hablar(frases_compra.pick_random())
	else:
		audio_efectos.stream = sonido_error
		audio_efectos.play()
		_hablar(frases_error.pick_random())
		
	if boton.disabled:
		return
	boton.disabled = true
	await get_tree().create_timer(0.3).timeout  # evita spam de click
	boton.disabled = false
	

# ================================
# 🔹 MARCAR COMO COMPRADO
# ================================
func _marcar_comprado(boton: TextureButton):
	boton.disabled = true
	boton.modulate = Color(0.6, 0.6, 0.6, 1)
	boton.mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN

# ================================
# 🔹 HABLAR CON SUBTÍTULOS
# ================================
var cola_dialogos: Array[String] = []

func _hablar(texto: String):
	# Si ya está hablando, encola el texto y sale
	if hablando:
		cola_dialogos.append(texto)
		return

	hablando = true
	salesman.texture = salesman_habla
	salesman.rotation_degrees = rot_habla
	voz_salesman.stream = sonido_voz
	voz_salesman.play()

	# tiempo proporcional al texto
	var duracion_texto = texto.length() * 0.025 + 0.1
	await _escribir_subtitulos(texto)
	await get_tree().create_timer(duracion_texto).timeout

	voz_salesman.stop()
	salesman.texture = salesman_normal
	salesman.rotation_degrees = rot_normal
	subtitulos.text = ""
	hablando = false

	# ✅ Si hay diálogos en la cola, decir el siguiente
	if not cola_dialogos.is_empty():
		var siguiente = cola_dialogos.pop_front()
		_hablar(siguiente)


# ================================
# 🔹 EFECTO DE ESCRITURA
# ================================
func _escribir_subtitulos(texto: String):
	subtitulos.text = ""
	for letra in texto:
		subtitulos.text += letra
		await get_tree().create_timer(0.04).timeout

# ================================
# 🔹 SALIR DE LA TIENDA
# ================================
func _salir():
	await fade_audio(musica_tienda, -80.0, 1.5) # Fade out
	audio_efectos.stream = sonido_despedida
	audio_efectos.play()
	_hablar(frases_despedida.pick_random())
	await get_tree().create_timer(3.0).timeout
	Global.guardar_cañas()
	get_tree().change_scene_to_file("res://Scene/main_juego.tscn")

func fade_audio(audio: AudioStreamPlayer, objetivo_db: float, duracion: float = 1.5):
	var inicio = audio.volume_db
	var tiempo = 0.0
	while tiempo < duracion:
		tiempo += get_process_delta_time()
		audio.volume_db = lerp(inicio, objetivo_db, tiempo / duracion)
		await get_tree().create_timer(0.01).timeout  # Espera un frame estable
