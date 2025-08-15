extends CharacterBody2D
var velocidad = 200
var direccion = Vector2(1, 0)  # Moverse hacia la derecha inicialmente
var distancia_maxima = 600
var distancia_recorrida = 0


func _physics_process(delta):
	var movimiento = direccion * velocidad * delta
	move_and_slide()  
	# Si usas Node2D:
	position += movimiento

	distancia_recorrida += velocidad * delta

	if distancia_recorrida >= distancia_maxima:
		direccion = -direccion
		distancia_recorrida = 0
		mirar_hacia_direccion()

func mirar_hacia_direccion():
	var sprite = $Sprite2D
	if direccion.x < 1:
		sprite.flip_h = false  # Mira a la derecha
	else:
		sprite.flip_h = true   # Mira a la izquierda
