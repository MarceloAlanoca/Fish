extends CharacterBody2D

@onready var inventory_ui = get_node("/root/MainJuego/CanvasLayer/InventoryUI")
@onready var caña = $"CañaPesca"  # hijo directo del Pescador
@onready var sprite_barco: Sprite2D = $"Sprite2D"   # el sprite del barco
@onready var nodo_caña: Node2D = $"CañaPesca"        # para mover la caña según el barco equipado


@export var velocidad: float = 300
@export var multiplicador_velocidad_pesca: float = 0.05  # 0 = bloqueo total, 0.1-0.3 = ralentizado

var _bloquear_izquierda := false
var _bloquear_derecha := false



var pos_y_real_base: float = 0.0
var puede_moverse := true
var is_facing_right := true
var pescando := false

func _ready():
	await get_tree().process_frame   # <-- dejar que todo cargue
	pos_y_real_base = position.y     # <-- se guarda la base REAL y FINAL

	# 1) Cargar cañas
	Global.cargar_cañas()

	# 2) Reaplicar sprite
	Global.aplicar_sprite_guardado(self)
	_conectar_caña()

	await get_tree().process_frame

	# 3) Preparar bases
	Global._preparar_base_pescador(self)

	# 4) Reaplicar amuletos (sin barco)
	Global.reaplicar_efectos_pescador(self, false)

	# 5) Efectos de caña
	var caña_nodo = get_node_or_null("CañaPesca")
	var anzuelo_nodo = get_node_or_null("CañaPesca/Caña/Anzuelo")
	if caña_nodo and anzuelo_nodo:
		Global.aplicar_efectos_caña(caña_nodo, anzuelo_nodo, self)

	# 6) Cargar barcos
	Global.cargar_barcos()
	Global.cargar_barco_equipado()

	# 7) APLICAR BARCO (SIEMPRE AL FINAL, Y NO TOCAR MÁS LA VELOCIDAD)
	if Global.barco_equipado != "":
		Global.aplicar_barco(self)

	# 8) APLICAR SKIN DEL PESCADOR
	Global.aplicar_skin(self)

	# --- FORZAR ORIENTACIÓN INICIAL ---
	_flip_sprite(-1) # -1 = mirando a la izquierda

func _conectar_caña():
	if not caña or not is_instance_valid(caña):
		caña = get_node_or_null("CañaPesca")
	if caña and not caña.is_connected("pesca_iniciada", Callable(self, "_on_pesca_iniciada")):
		caña.connect("pesca_iniciada", Callable(self, "_on_pesca_iniciada"))
		caña.connect("pesca_terminada", Callable(self, "_on_pesca_terminada"))
		print("✅ Señales de pesca conectadas correctamente.")


func _process(delta):
	# SOLO PARA DEBUG, luego lo borrás
	if Input.is_action_just_pressed("ui_accept"):
		print("🔥 DEBUG SPEED:", velocidad)


	if Input.is_action_just_pressed("ui_left"):
		inventory_ui.visible = true
	if Input.is_action_just_pressed("ui_right"):
		inventory_ui.visible = false

	if not puede_moverse:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var dir = Vector2.ZERO
	var ui := get_node("../CanvasLayer/InterfazUsuario")

	# === CONTROLES DE PC ===
	var move_left := Input.is_action_pressed("Move_A")
	var move_right := Input.is_action_pressed("Move_D")

	# === CONTROLES DE MÓVIL ===
	if ui:
		move_left = move_left or ui.izquierda_pulsado
		move_right = move_right or ui.derecha_pulsado

	# === BLOQUEOS ===
	if move_right and not _bloquear_derecha:
		dir.x += 1
	if move_left and not _bloquear_izquierda:
		dir.x -= 1
		
	

	var speed := self.velocidad  

	if pescando:
		speed *= multiplicador_velocidad_pesca


	# ==========================
	#  🔧 ACTUALIZAR BOTONES UI 
	# ==========================
	if ui:
		# ❗ SOLO bloquear si hay pared
		ui.boton_derecha.disabled = _bloquear_derecha
		ui.boton_izquierda.disabled = _bloquear_izquierda

		# si se bloquea por pared, cancelar input del lado bloqueado
		if ui.boton_derecha.disabled:
			ui.derecha_pulsado = false
		if ui.boton_izquierda.disabled:
			ui.izquierda_pulsado = false


			# DEBUG (¡IMPORTANTE!)
			print("UI → izq:", ui.izquierda_pulsado, " der:", ui.derecha_pulsado,
			"| disabled izq:", ui.boton_izquierda.disabled,
			" der:", ui.boton_derecha.disabled)


	velocity = dir.normalized() * speed
	move_and_slide()
	_flip_sprite(dir.x)

func _flip_sprite(dir_x):
	var barco_sprite = $Sprite2D
	var george = $George

	if not Global.POS_GEORGE.has(Global.barco_equipado):
		return

	var cfg = Global.POS_GEORGE[Global.barco_equipado]

	# Escala vertical fija
	george.scale.y = cfg["scale"].y  

	if dir_x < 0: # izquierda
		barco_sprite.flip_h = false
		george.scale.x = cfg["scale"].x  # positivo
		george.position = cfg["left"]

	elif dir_x > 0: # derecha
		barco_sprite.flip_h = true
		george.scale.x = -cfg["scale"].x  # invertimos solo X
		george.position = cfg["right"]


# ==========================================
# EVENTOS DE PESCA
# ==========================================
func _on_pesca_iniciada():
	pescando = true
	if multiplicador_velocidad_pesca <= 0.0:
		puede_moverse = false
	print("🚫 Movimiento ralentizado/bloqueado por pesca")

func _on_pesca_terminada():
	pescando = false
	puede_moverse = true
	print("✅ Movimiento restaurado después de la pesca")
