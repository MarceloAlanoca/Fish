extends Area2D

# ==============================
# CONFIGURACIÓN
# ==============================
@export var velocidad_recoger := 300
@export var fuerza_lanzamiento := 1000
@export var gravedad := 1600
@export var distancia_maxima := 2000

enum Estado { INACTIVO, LANZADO, RECOGIENDO }
var estado := Estado.INACTIVO

# ==============================
# VARIABLES
# ==============================
var velocidad_anzuelo := Vector2.ZERO
var posicion_inicial := Vector2.ZERO
var pez_atrapado: Node = null
var modificador_probabilidad := 1.0

# ==============================
# REFERENCIAS
# ==============================
@onready var collision_shape := $CollisionShape2D
@onready var sprite := $Sprite2D
@onready var ui := get_tree().current_scene.get_node_or_null("CanvasLayer")
@onready var libocap := ui.get_node_or_null("LibOCap") if ui else null
@onready var inventory_ui = get_node_or_null("/root/MainJuego/CanvasLayer/InventoryUI")
@onready var Tirar := get_node("/root/MainJuego/CanvasLayer/InterfazUsuario/Lanzar")


# ==============================
# DATOS EXTERNOS
# ==============================
var Box = load("res://Scripts/FishBox.gd")
var Box_Cap = Box.new()

# ==============================
# MINIJUEGO
# ==============================
var minijuego_escena := preload("res://Scene/pescar_minigame.tscn")

# ==============================
# READY
# ==============================
func _ready():
	add_to_group("anzuelo")
	posicion_inicial = position
	connect("body_entered", Callable(self, "_on_body_entered"))
	if Tirar:
		Tirar.pressed.connect(_on_tirar_boton)
	print("🎣 Anzuelo listo en posición:", posicion_inicial)

	# 💎 Aplicar efectos globales de amuletos
	Global.aplicar_efectos_anzuelo(self)

# ==============================
# COLISIÓN CON PECES
# ==============================
func _on_body_entered(body):
	if body.is_in_group("peces") and pez_atrapado == null:
		var probabilidad := obtener_probabilidad_captura(body.name)
		if randf() <= probabilidad:
			pez_atrapado = body
			if body.has_method("detener_movimiento"):
				body.detener_movimiento()
			_transformar_a_bola(pez_atrapado)
			collision_shape.disabled = true
			print("🎯 ¡Pez atrapado!: ", body.name)
			_iniciar_minijuego()
		else:
			print("💨 El pez escapó:", body.name)

# ==============================
# BOTÓN TIRAR (reemplaza ui_accept)
# ==============================
func _on_tirar_boton():
	match estado:
		Estado.INACTIVO:
			_lanzar()
		Estado.LANZADO:
			_empezar_recoger()

# ==============================
# LANZAR Y RECOGER
# ==============================
func _lanzar():
	if estado != Estado.INACTIVO:
		return
	estado = Estado.LANZADO
	var angulo = deg_to_rad(-45)
	velocidad_anzuelo = Vector2(cos(angulo), sin(angulo)) * fuerza_lanzamiento
	print("🏹 Lanzando anzuelo...")
	if inventory_ui:
		inventory_ui.visible = false

func _empezar_recoger():
	if estado != Estado.LANZADO:
		return
	estado = Estado.RECOGIENDO
	print("↩️ Recogiendo anzuelo...")

# ==============================
# MOVIMIENTO
# ==============================
func _physics_process(delta):
	# Si el anzuelo mueve su propia física, mantenelo. Si no, no pasa nada.
	if estado == Estado.LANZADO:
		_mover_lanzamiento(delta)
	elif estado == Estado.RECOGIENDO:
		_mover_recoger(delta)

	# ✅ SIEMPRE mantener al pez pegado al anzuelo si existe,
	#    aunque no estemos en LANZADO/RECOGIENDO (después del minijuego).
	_actualizar_pez()

func _mover_lanzamiento(delta):
	velocidad_anzuelo.y += gravedad * delta
	position += velocidad_anzuelo * delta
	if position.distance_to(posicion_inicial) > distancia_maxima:
		var dir = (position - posicion_inicial).normalized()
		position = posicion_inicial + dir * distancia_maxima
		velocidad_anzuelo = Vector2.ZERO

func _mover_recoger(delta):
	if position.distance_to(posicion_inicial) > 5:
		position = position.move_toward(posicion_inicial, velocidad_recoger * delta)
	else:
		position = posicion_inicial
		velocidad_anzuelo = Vector2.ZERO
		estado = Estado.INACTIVO
		collision_shape.disabled = false
		if pez_atrapado:
			_mostrar_lib_ocap()

# ==============================
# MOSTRAR PANEL UI
# ==============================
func _mostrar_lib_ocap():
	if libocap:
		libocap.mostrar_panel(pez_atrapado)
		print("📋 Panel LibOCap mostrado")
	else:
		push_error("⚠️ No se encontró el nodo 'LibOCap'.")

# ==============================
# PEZ PEGADO AL ANZUELO
# ==============================
func _actualizar_pez():
	if pez_atrapado:
		pez_atrapado.global_position = global_position

# ==============================
# PROBABILIDAD DE CAPTURA
# ==============================
func obtener_probabilidad_captura(nombre_pez: String) -> float:
	var clave = ""
	if "Atun" in nombre_pez:
		clave = "CapAtun"
	elif "Salmon" in nombre_pez:
		clave = "CapSalmon"
	elif "Orca" in nombre_pez:
		clave = "CapOrca"
	elif "Barracuda" in nombre_pez:
		clave = "CapBarracuda"
	elif "Lenguado" in nombre_pez:
		clave = "CapLenguado"
	elif "Payaso" in nombre_pez:
		clave = "CapPayaso"
	elif "Ballena" in nombre_pez:
		clave = "CapBallena"

	if Box_Cap.Porcentaje_Captura.has(clave):
		return Box_Cap.Porcentaje_Captura[clave] * modificador_probabilidad
	else:
		return 0.5 * modificador_probabilidad
		
# ==============================
# TRANSFORMAR PEZ EN BOLA
# ==============================
func _transformar_a_bola(pez: Node):
	if pez == null:
		return
	if pez is CharacterBody2D:
		pez.velocity = Vector2.ZERO

	var shape = pez.get_node_or_null("CollisionShape2D")
	if shape:
		shape.disabled = true

	for c in pez.get_children():
		if c is Sprite2D or c is AnimatedSprite2D:
			c.queue_free()

	var bola = Sprite2D.new()
	bola.name = "BolaCaptura"
	bola.texture = load("res://Assets/Capturas/Captura normal.png")
	bola.scale = Vector2(0.6, 0.6)
	pez.add_child(bola)
	bola.position = Vector2.ZERO

	var tween = get_tree().create_tween()
	bola.modulate = Color(1, 1, 1, 0)
	tween.tween_property(bola, "modulate:a", 1, 0.2)
	print("✨ Pez transformado en bola de captura")

# ==============================
# LIBERAR / GUARDAR PEZ
# ==============================
func liberar_pez():
	if pez_atrapado:
		print("🐠 Liberando pez:", pez_atrapado.name)
		pez_atrapado.queue_free()
		pez_atrapado = null

func guardar_pez():
	if pez_atrapado:
		print("🎁 Guardando pez:", pez_atrapado.name)
		pez_atrapado.queue_free()
		pez_atrapado = null

# ==============================
# MINIJUEGO
# ==============================
func _iniciar_minijuego():
	var minijuego = minijuego_escena.instantiate()
	get_tree().root.add_child(minijuego)
	minijuego.connect("finalizado", Callable(self, "_on_minijuego_finalizado"))
	print("🎮 Minijuego iniciado desde el anzuelo")

	var caña = get_node_or_null("/root/MainJuego/CañaPesca")
	if caña:
		caña.minijuego_activo = true

	get_tree().root.add_child(minijuego)
	minijuego.connect("finalizado", Callable(self, "_on_minijuego_finalizado"))

func _on_minijuego_finalizado(resultado: bool):
	print("🎮 Minijuego finalizado → Resultado:", resultado)

	# Si pierde el minijuego, liberar el pez inmediatamente
	if not resultado:
		print("❌ Minijuego perdido: liberando pez antes de recoger.")
		liberar_pez()

	# 🔔 Avisar a la caña para que haga la recogida automática
	var caña := get_node_or_null("/root/MainJuego/CañaPesca")
	if caña and caña.has_method("_on_minijuego_finalizado"):
		caña._on_minijuego_finalizado(resultado)
	else:
		push_warning("⚠️ No se encontró la caña o falta _on_minijuego_finalizado en CañaPesca")
