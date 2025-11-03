extends CanvasLayer

signal minijuego_finalizado(resultado_exitoso: bool)
@onready var fondo_barra = $Control/FondoBarra
@onready var zona_pez = $Control/FondoBarra/ZonaPez
@onready var zona_jugador = $Control/FondoBarra/ZonaJugador
@onready var barra_progreso = $Control/ProgresoBarra
@onready var timer = $Control/Timer

@export var velocidad_pez: float = 250.0
@export var velocidad_jugador: float = 400.0
@export var perdida_por_segundo: float = 0.2
@export var ganancia_por_segundo: float = 0.4

var direccion_pez := 1
var progreso := 0.0
var en_juego := false
var fuera_zona_tiempo := 0.0

func _ready():
	hide()
	barra_progreso.value = 0

func iniciar_minijuego():
	show()
	en_juego = true
	progreso = 0
	fuera_zona_tiempo = 0
	zona_pez.position.x = randf_range(0, fondo_barra.size.x - zona_pez.size.x)
	zona_jugador.position.x = (fondo_barra.size.x / 2.0) - (zona_jugador.size.x / 2.0)

func finalizar_minijuego(resultado_exitoso: bool):
	en_juego = false
	hide()
	emit_signal("minijuego_finalizado", resultado_exitoso)

func _process(delta):
	if not en_juego:
		return

	_mover_pez(delta)
	_mover_jugador(delta)
	verificar_colision(delta)

func _mover_pez(delta):
	zona_pez.position.x += velocidad_pez * delta * direccion_pez
	if zona_pez.position.x <= 0 or zona_pez.position.x + zona_pez.size.x >= fondo_barra.size.x:
		direccion_pez *= -1  # rebota en los bordes

func _mover_jugador(delta):
	if Input.is_action_pressed("ui_right"):
		zona_jugador.position.x = clamp(zona_jugador.position.x + velocidad_jugador * delta, 0, fondo_barra.size.x - zona_jugador.size.x)
	if Input.is_action_pressed("ui_left"):
		zona_jugador.position.x = clamp(zona_jugador.position.x - velocidad_jugador * delta, 0, fondo_barra.size.x - zona_jugador.size.x)

func verificar_colision(delta):
	var jugador_rect = Rect2(zona_jugador.position, zona_jugador.size)
	var pez_rect = Rect2(zona_pez.position, zona_pez.size)

	if jugador_rect.intersects(pez_rect):
		fuera_zona_tiempo = 0
		progreso += ganancia_por_segundo * delta
	else:
		fuera_zona_tiempo += delta
		progreso -= perdida_por_segundo * delta

	barra_progreso.value = clamp(progreso * 100, 0, 100)

	if progreso >= 1.0:
		finalizar_minijuego(true)
	elif fuera_zona_tiempo >= 3.0:
		finalizar_minijuego(false)
		
