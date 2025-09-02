extends CharacterBody2D

var velocidad: float = 200
var direccion: Vector2 = Vector2(1, 0)  # Empieza hacia la derecha
var distancia_maxima: float = 1200
var distancia_recorrida: float = 0

var enganchado: bool = false
var anzuelo: Node = null


func _physics_process(delta: float) -> void:
	if enganchado and anzuelo:
		# Si está enganchado, sigue al anzuelo
		global_position = anzuelo.global_position
		return

	# Movimiento normal (IA simple)
	var movimiento = direccion * velocidad * delta
	position += movimiento
	distancia_recorrida += velocidad * delta

	if distancia_recorrida >= distancia_maxima:
		direccion = -direccion
		distancia_recorrida = 0
		mirar_hacia_direccion()


func mirar_hacia_direccion() -> void:
	var sprite = $Sprite2D
	if direccion.x < 0:
		sprite.flip_h = false  # mira a la derecha
	else:
		sprite.flip_h = true   # mira a la izquierda


func set_enganchado(estado: bool, hook: Node) -> void:
	enganchado = estado
	anzuelo = hook
	if estado:
		print("🐟 Me enganché en el anzuelo")
	else:
		print("✅ Me soltaron")
