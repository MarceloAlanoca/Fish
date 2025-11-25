extends CharacterBody2D

var Box = load("res://Scripts/FishBox.gd")
var Box_Vel = Box.new()

@export var nombre_real := "OutcomeMemories"
@export var calidad := "Secreto"
@export var vel_progresion := 0.5

# ===========================
# VELOCIDAD BASE
# ===========================
var velocidad_base: float = float(Box_Vel.VelP["OutcomeMemoriesVelocity"])
var velocidad: float = velocidad_base
var direccion: Vector2 = Vector2(1, 0)
var distancia_maxima: float = float(Box_Vel.Dist["DistOutcomeMemories"])
var distancia_recorrida: float = 0.0
var detenido: bool = false

# ===========================
# EXPORTABLES
# ===========================
@export var tiempo_aceleracion := 10.0     # tiempo para llegar a velocidad x3
@export var factor_maximo := 3.0          # velocidad máxima multiplicada

@export var sonido_cercania: AudioStreamPlayer2D
@export var sonido_eggman: AudioStreamPlayer2D
@export var zona_proximidad: Area2D
@export var zona_anzuelo: Area2D
@export var estela: CPUParticles2D
@export var pivote_estela: Node2D


# Internos
var jugador_cerca := false
var acelerando := false
var tiempo_sonido := 0.0
var tiempo_loops := 5.0

func _ready():
	add_to_group("peces")
	name = nombre_real
	set_meta("nombre_real", nombre_real)

	if randf() > 0.5:
		direccion = -direccion
	mirar_hacia_direccion()

	if zona_proximidad:
		zona_proximidad.body_entered.connect(_on_jugador_enter)
		zona_proximidad.body_exited.connect(_on_jugador_exit)

	if zona_anzuelo:
		zona_anzuelo.body_entered.connect(_on_anzuelo_enter)

func _physics_process(delta):
	if detenido:
		return

	# ====== Sonido cada 5 segundos si jugador cerca ======
	if jugador_cerca:
		tiempo_sonido += delta
		if tiempo_sonido >= tiempo_loops:
			tiempo_sonido = 0
			if sonido_cercania:
				sonido_cercania.play()

	# ===== Movimiento ======
	var mov = direccion * velocidad * delta
	position += mov
	distancia_recorrida += velocidad * delta

	if distancia_recorrida >= distancia_maxima:
		direccion = -direccion
		distancia_recorrida = 0
		mirar_hacia_direccion()

func mirar_hacia_direccion():
	# El pez mira normal con flip_h
	if $Sprite2D:
		$Sprite2D.flip_h = direccion.x > 0

	# Rotar solo el pivote
	if pivote_estela:
		pivote_estela.scale.x = -1 if direccion.x > 0 else 1


# ========================================================
# ⭐ EFECTO: ACELERACIÓN PROGRESIVA CUANDO DETECTA ANZUELO
# ========================================================
func _on_anzuelo_enter(body):
	if "Anzuelo" in str(body):
		if not acelerando:
			acelerando = true
			_start_aceleracion()

func _start_aceleracion():
	var t := 0.0
	var vel_inicial := velocidad_base
	var vel_objetivo := velocidad_base * factor_maximo

	estela.emitting = true

	while t < tiempo_aceleracion:
		var alpha = t / tiempo_aceleracion
		velocidad = lerp(vel_inicial, vel_objetivo, alpha)
		t += get_physics_process_delta_time()
		await get_tree().process_frame

	# mantener velocidad máxima un rato
	await get_tree().create_timer(3.0).timeout

	# luego bajar progresivamente
	var t2 := 0.0
	while t2 < 4.0:
		var a = t2 / 4.0
		velocidad = lerp(vel_objetivo, velocidad_base, a)
		t2 += get_physics_process_delta_time()
		await get_tree().process_frame

	velocidad = velocidad_base
	acelerando = false
	estela.emitting = false

# ========================================================
# ⭐ EFECTO: SONIDO SI JUGADOR CERCA
# ========================================================
func _on_jugador_enter(body):
	if "Pescador" in str(body):
		jugador_cerca = true

func _on_jugador_exit(body):
	if "Pescador" in str(body):
		jugador_cerca = false

# ========================================================
# ⭐ EFECTO: MÚSICA SI EL PESCADOR TIENE SKIN EGGMAN
# ========================================================
func reproducir_musica_eggman():
	if Global.skin_equipada == "Eggman":
		if sonido_eggman:
			sonido_eggman.play()

func detener_movimiento():
	velocidad = 0
	detenido = true
	set_physics_process(false)
