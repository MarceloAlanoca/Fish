extends Area2D
var debug_timer := 0.0
var debug_interval := 3.0  # cada 3 segundos

# ==============================
# CONFIGURACIÓN
# ==============================
@export var gravedad := 1200.0
@export var fuerza_lanzamiento := 20
@export var distancia_maxima := 450.0
@export var velocidad_vertical := 60.0
@export var velocidad_recogida_manual := 80.0
@export var limite_superior_base := 600.0
@export var limite_inferior_base := 1250.0
@export var tiempo_necesario := 3.0
@export var resistencia_agua := 30  # Multiplicador de velocidad al entrar al agua
@onready var ray_derecha = $CollisionShape2D/RayDerecha
@onready var ray_izquierda = $CollisionShape2D/RayIzquierda
@onready var ray_abajo = $CollisionShape2D/RayAbajo

var bloqueado_por_pared := false
var minijuego: Node = null
var minijuego_conectado := false
var recogida_automatica_en_progreso := false
var caña = get_node_or_null("/root/MainJuego/CañaPesca")
var recogida_automatica := false
var bloqueado_por_minijuego := false
var limite_superior := 0.0
var limite_inferior := 0.0
var subir_pulsado := false
var bajar_pulsado := false
var dentro_del_agua := false
var tiempo_en_agua := 0.0
@export var tiempo_caida_en_agua := 5.0
var tiempo_caida_actual := 0.0
var en_transicion_caida := false
var botones_mostrados := false
var puede_atrapar := true   # Bloquea capturas durante los primeros segundos bajo el agua
var botones_bloqueados := false  # Controla si los botones están deshabilitados
var pesca_habilitada := true

# ==============================
# LUZ DEL ANZUELO
# ==============================
@onready var luz_anzuelo := $SpriteAnzuelo/LuzAnzuelo


var luz_actual := 0.0         # energía actual
var luz_objetivo := 0.0       # energía hacia donde debe ir
var velocidad_luz := 1.5      # suavizado (más alto = más rápido)



enum Estado { INACTIVO, LANZADO, RECOGIENDO }

func _dump_estado(tag:String):
	print("[ANZUELO]", tag,
		" | estado=", estado,
		" | pos=", Vector2(round(position.x), round(position.y)),
		" | pos_ini=", Vector2(round(posicion_inicial.x), round(posicion_inicial.y)),
		" | dentro_agua=", dentro_del_agua,
		" | en_trans_caida=", en_transicion_caida,
		" | recogida_auto=", recogida_automatica,
		" | rec_auto_prog=", recogida_automatica_en_progreso,
		" | bloqueado_minig=", bloqueado_por_minijuego)

var estado := Estado.INACTIVO

# ==============================
# VARIABLES
# ==============================
var velocidad_anzuelo := Vector2.ZERO
var posicion_inicial := Vector2.ZERO
var pez_atrapado: Node = null
var modificador_probabilidad := 1.0
var nombre_pez_actual: String = ""

# ==============================
# REFERENCIAS
# ==============================
@onready var collision_shape := $CollisionShape2D
@onready var sprite := $SpriteAnzuelo
@onready var libocap := ui.get_node_or_null("LibOCap") if ui else null
@onready var inventory_ui = get_node_or_null("/root/MainJuego/CanvasLayer/InventoryUI")
@onready var Tirar := get_node_or_null("/root/MainJuego/CanvasLayer/InterfazUsuario/Lanzar")
# Conexión de botones de subir/bajar
@onready var ui := get_tree().root.get_node_or_null("MainJuego/CanvasLayer/InterfazUsuario")
@onready var boton_subir := get_node_or_null("/root/MainJuego/CanvasLayer/InterfazUsuario/BotonSubir")
@onready var boton_bajar := get_node_or_null("/root/MainJuego/CanvasLayer/InterfazUsuario/BotonBajar")




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
	print("💡 LUZ:", luz_anzuelo)
	add_to_group("anzuelo")
	posicion_inicial = position
	limite_superior = limite_superior_base
	limite_inferior = limite_inferior_base
	_reset_ui_state()


	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("area_entered", Callable(self, "_on_area_entered"))
	connect("area_exited", Callable(self, "_on_area_exited"))

	# ====== CONEXIONES DE BOTONES ======
	if boton_subir:
		boton_subir.visible = false
		boton_subir.focus_mode = Control.FOCUS_ALL
		boton_subir.mouse_filter = Control.MOUSE_FILTER_STOP
		boton_subir.pressed.connect(func():
			#print("⬆️ PRESSED subir")
			subir_pulsado = true
			bajar_pulsado = false)
		boton_subir.button_up.connect(func():
			#print("⬆️ UP subir")
			subir_pulsado = false)

	if boton_bajar:
		boton_bajar.visible = false
		boton_bajar.focus_mode = Control.FOCUS_ALL
		boton_bajar.mouse_filter = Control.MOUSE_FILTER_STOP
		boton_bajar.pressed.connect(func():
			#print("⬇️ PRESSED bajar")
			bajar_pulsado = true
			subir_pulsado = false)
		boton_bajar.button_up.connect(func():
			#print("⬇️ UP bajar")
			bajar_pulsado = false)

	print("✅ Botones conectados para movimiento manual")
	print("🎣 Anzuelo listo en posición:", posicion_inicial)
	_dump_estado("READY")




	# 🔗 Conexión de botones
	if boton_subir:
		boton_subir.visible = false
		boton_subir.action_mode = BaseButton.ACTION_MODE_BUTTON_PRESS
		boton_subir.shortcut_in_tooltip = false
		boton_subir.pressed.connect(Callable(self, "_subir_caña"))

	if boton_bajar:
		boton_bajar.visible = false
		boton_bajar.action_mode = BaseButton.ACTION_MODE_BUTTON_PRESS
		boton_bajar.shortcut_in_tooltip = false
		boton_bajar.pressed.connect(Callable(self, "_bajar_caña"))

	var pescador = get_node_or_null("/root/MainJuego/Pescador")
	var caña = get_node_or_null("/root/MainJuego/Pescador/CañaPesca")
	Global.aplicar_efectos_caña(caña, self, pescador)

	print("🎣 Anzuelo listo en posición:", posicion_inicial)
	
	if boton_subir and boton_bajar:
		print("✅ Botones detectados correctamente.")
	else:
		print("❌ No se encontraron los botones del UI.")

	print("💡 Nodo Anzuelo listo con nombre:", name)

func _on_body_entered(body):

	# ==============================
	# 1. COLISIÓN CON PARED LATERAL
	# ==============================
	if body.is_in_group("pared"):
		print("🚫 Anzuelo chocó con la pared → REBOTE")

		# Bloquear movimiento
		velocidad_anzuelo = Vector2.ZERO
		bajar_pulsado = false
		subir_pulsado = false

		# Rebote suave hacia el agua
		if global_position.x > 0:
			position.x -= 6
		else:
			position.x += 6

		# Deshabilitar bajar
		if boton_bajar:
			boton_bajar.disabled = true

		return


	# ===================================
	# 2. SI AÚN NO PUEDE ATRAPAR, IGNORAR
	# ===================================
	if not pesca_habilitada:
		return

	if not puede_atrapar:
		return


	# ==============================
	# 3. COLISIÓN CON PEZ
	# ==============================
	if body.is_in_group("peces") and pez_atrapado == null:

		pez_atrapado = body
		nombre_pez_actual = body.name

		if body.has_method("detener_movimiento"):
			body.detener_movimiento()

		_transformar_a_bola(pez_atrapado)
		collision_shape.disabled = true
		print("🎯 ¡Pez atrapado directamente!: ", nombre_pez_actual)

		# Descativar límites y empezar minijuego
		_desactivar_limites_temporal()
		_iniciar_minijuego()

func _on_body_exited(body):
	if body.is_in_group("pared"):
		print("✔ Anzuelo salió de la pared → bajar habilitado")

		if boton_bajar:
			boton_bajar.disabled = false


# ==============================
# BOTÓN "LANZAR"
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
	
	# 🔁 Reinicia físicas completamente
	velocidad_anzuelo = Vector2.ZERO
	gravedad = 1200.0

	estado = Estado.LANZADO
	
	# 🎯 Cálculo del ángulo corregido: que siempre vaya HACIA ABAJO
	var angulo = deg_to_rad(45)  # <-- sin el signo menos
	velocidad_anzuelo = Vector2(cos(angulo), sin(angulo)) * fuerza_lanzamiento
	velocidad_anzuelo.y = abs(velocidad_anzuelo.y)  # fuerza la dirección hacia abajo

	print("🏹 Lanzando anzuelo... Velocidad inicial:", velocidad_anzuelo)
	
	if inventory_ui:
		inventory_ui.visible = false

	_dump_estado("LANZAR() -> LANZADO")


func _empezar_recoger():
	# 🔹 Si ya está recogiendo, no repetir
	if ui:
		ui.boton_anzuelo_on.disabled = true
		ui.boton_anzuelo_off.disabled = true
	
	if estado == Estado.RECOGIENDO:
		print("🚫 _empezar_recoger cancelado: ya en recogida.")
		return

	print("🟠 _empezar_recoger() → inicio de recogida manual")
	# 🔹 Permite iniciar aunque estado sea INACTIVO o LANZADO
	estado = Estado.RECOGIENDO
	recogida_automatica = true
	en_transicion_caida = false
	dentro_del_agua = false
	puede_atrapar = false
	bloqueado_por_minijuego = true

	print("🔒 Bloqueando botones y desactivando límites...")
	_ocultar_botones()
	botones_mostrados = false
	if Tirar: Tirar.disabled = true
	if boton_subir: boton_subir.disabled = true
	if boton_bajar: boton_bajar.disabled = true
	_oscurecer_anzuelo()   # ← AÑADIR AQUÍ

	limite_superior = -INF
	limite_inferior = INF
	print("✅ Limites desactivados correctamente.")

	_dump_estado("_empezar_recoger() ENTER")


# ==============================
# MOVIMIENTO
# ==============================
func _physics_process(delta):
			
	# 🌊 Fase 1: transición de caída dentro del agua
	if en_transicion_caida:
		tiempo_caida_actual += delta
		velocidad_anzuelo.y += gravedad * delta * 0.03
		velocidad_anzuelo.y = clamp(velocidad_anzuelo.y, -50, 200)

		position.y += velocidad_anzuelo.y * delta
		position.y = clamp(position.y, limite_superior, limite_inferior)

		if tiempo_caida_actual >= tiempo_caida_en_agua:
			en_transicion_caida = false
			dentro_del_agua = true
			puede_atrapar = true
			tiempo_en_agua = 0.0
			velocidad_anzuelo = Vector2.ZERO
			print("🐟 Control manual activado tras 5 s de caída en agua.")
		return

	# 💧 Fase 2: control manual dentro del agua
	if dentro_del_agua:
		# 1️⃣ detectar paredes primero
		_detectar_paredes()

		# 2️⃣ actualizar estado de botones
		_actualizar_estado_botones()

		# 3️⃣ si minijuego o recogida → bloquear movimiento
		if bloqueado_por_minijuego or recogida_automatica:
			subir_pulsado = false
			bajar_pulsado = false
			_comprobar_agua(delta)
			return

		var moved := false

		# 4️⃣ Movimiento manual
		if subir_pulsado and position.y > limite_superior + 10:
			position.y -= velocidad_vertical * delta
			moved = true
		elif bajar_pulsado and position.y < limite_inferior - 10:
			position.y += velocidad_vertical * delta
			moved = true

		# clamp final
		position.y = clamp(position.y, limite_superior, limite_inferior)

		# 5️⃣ Actualización final de botones
		_actualizar_estado_botones()
		_comprobar_agua(delta)
		return

	# -------------------------------
	# 🚀 FASE 3: comportamiento normal
	# -------------------------------
	if estado == Estado.LANZADO:
		_mover_lanzamiento(delta)
	elif estado == Estado.RECOGIENDO or recogida_automatica:
		_mover_recoger(delta)

	_actualizar_pez()
	_comprobar_agua(delta)

	# 🌟 Luz del anzuelo (si la reactivás)
	# if luz_anzuelo:
	# 	luz_actual = lerp(luz_actual, luz_objetivo, delta * velocidad_luz)
	# 	luz_anzuelo.energy = luz_actual


func _actualizar_estado_botones():
	# 🧱 SI ESTAMOS BLOQUEADOS POR PARED, NO PERMITIR QUE EL UI TOQUE NADA
	if bloqueado_por_pared:
		if boton_subir:
			boton_subir.disabled = false
		if boton_bajar:
			boton_bajar.disabled = true
		return

	if not boton_subir or not boton_bajar:
		return

	# Si el minijuego pide bloqueo, todo deshabilitado
	if bloqueado_por_minijuego:
		boton_subir.disabled = true
		boton_bajar.disabled = true
		return

	var en_superficie := position.y <= limite_superior + 2.0
	var en_fondo := position.y >= limite_inferior - 2.0

	boton_subir.disabled = false   # 🔥 nunca se desactiva
	boton_bajar.disabled = (not dentro_del_agua) or en_fondo


	# DEBUG TRACK: quién cambia el botón
	print("⚙️ _actualizar_estado_botones() → subir:", boton_subir.disabled, " bajar:", boton_bajar.disabled, " | bloqueado_por_pared:", bloqueado_por_pared)

			
# 🚫 Desactiva los límites mientras sube el anzuelo
func _desactivar_limites_temporal():
	print("🧩 Límites desactivados temporalmente (recogida o captura).")
	limite_superior = -INF
	limite_inferior = INF


func _restaurar_limites():
	print("✅ Límites restaurados (anzuelo libre).")
	limite_superior = limite_superior_base
	limite_inferior = limite_inferior_base
	_actualizar_estado_botones()


func _mover_lanzamiento(delta):
	# ✅ Aplica gravedad solo hacia abajo
	velocidad_anzuelo.y += gravedad * delta
	position += velocidad_anzuelo * delta

	# 🔒 Limita la distancia máxima de lanzamiento
	if position.distance_to(posicion_inicial) > distancia_maxima:
		var dir = (position - posicion_inicial).normalized()
		position = posicion_inicial + dir * distancia_maxima
		velocidad_anzuelo = Vector2.ZERO

	# 💧 Si el anzuelo toca el límite inferior (fondo del agua)
	if position.y >= limite_inferior - 1.0:
		position.y = limite_inferior
		
		# 🔹 Frenar la velocidad vertical
		velocidad_anzuelo.y = 0.0
		
		# 🔹 Simular resistencia del agua (frena el avance horizontal)
		velocidad_anzuelo.x = lerp(velocidad_anzuelo.x, 0.0, 0.15)

		# 🔹 Empieza un retroceso leve hacia el barco (posición inicial)
		var direccion_retorno = (posicion_inicial - position).normalized()
		position.x = lerp(position.x, posicion_inicial.x, 0.02)

		if not dentro_del_agua:
			velocidad_anzuelo.y = -abs(gravedad) * 0.1

		# 🔹 Marca que está en el agua (control de fase)
		dentro_del_agua = true


var __last_pos := Vector2.ZERO
var __stuck_frames := 0

func _mover_recoger(delta: float) -> void:
	if Tirar:
		Tirar.disabled = true
		
	if ui:
		ui.boton_anzuelo_on.disabled = true
		ui.boton_anzuelo_off.disabled = true
	limite_superior = -INF
	limite_inferior = INF
	dentro_del_agua = false

	var dist: float = position.distance_to(posicion_inicial)

	# Calcular paso de movimiento con suavizado
	var paso: float = velocidad_recogida_manual * delta
	if dist < 50.0:
		paso *= clamp(dist / 50.0, 0.25, 1.0)   # ← clamp en minúsculas

	position = position.move_toward(posicion_inicial, paso)

	print("⬆️ [AUTO] Subiendo... y=", round(position.y), " dist=", str(snapped(dist, 0.01)), " paso=", round(paso))

	if not dentro_del_agua and (estado == Estado.RECOGIENDO or recogida_automatica):
		print("[ANZUELO] FUERA DEL AGUA PERO RECOGIENDO | dist=", str(snapped(dist, 0.01)))

	if dist <= 5.0:
		print("[ANZUELO] OBJETIVO ALCANZADO → set INACTIVO + notificar caña")
		position = posicion_inicial
		if ui:
			ui.boton_anzuelo_on.disabled = false
			ui.boton_anzuelo_off.disabled = false
		velocidad_anzuelo = Vector2.ZERO
		estado = Estado.INACTIVO
		recogida_automatica = false
		bloqueado_por_minijuego = false
		collision_shape.disabled = false
		_restaurar_limites()
		_reset_ui_state()
		_iluminar_anzuelo() 

		# ✅ Notificar a la caña (sin tocar)
		var caña: Node = null
		var nodo_actual = self
		while nodo_actual != null:
			if nodo_actual.name == "CañaPesca":
				caña = nodo_actual
				break
			nodo_actual = nodo_actual.get_parent()
		if not caña:
			caña = get_node_or_null("/root/MainJuego/Pescador/CañaPesca")
		if not caña:
			for nodo in get_tree().get_nodes_in_group("caña"):
				caña = nodo
				break

		if caña and caña.has_method("_on_anzuelo_recogido"):
			print("[ANZUELO] ✅ Notificando a caña _on_anzuelo_recogido() — ruta:", caña.get_path())
			caña._on_anzuelo_recogido()
		else:
			print("[ANZUELO] ❌ No se pudo encontrar la caña para notificar — revisa la ruta exacta.")

# ==============================
# MOSTRAR PANEL UI
# ==============================
func _mostrar_lib_ocap():
	if nombre_pez_actual == "" and pez_atrapado:
		nombre_pez_actual = pez_atrapado.name
	if libocap and pez_atrapado:
		libocap.mostrar_panel(pez_atrapado, nombre_pez_actual)
		print("📋 Panel LibOCap mostrado con pez:", nombre_pez_actual)
	else:
		push_error("⚠️ No se encontró 'LibOCap' o no hay pez.")

# ==============================
# PEZ PEGADO AL ANZUELO
# ==============================
func _actualizar_pez():
	if pez_atrapado:
		pez_atrapado.global_position = global_position

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
		call_deferred("_reset_pez")

func guardar_pez():
	if pez_atrapado:
		print("🎁 Guardando pez:", pez_atrapado.name)
		pez_atrapado.queue_free()
		call_deferred("_reset_pez")
		
func _reset_pez():
	pez_atrapado = null
	collision_shape.disabled = false

# ==============================
# MINIJUEGO
# ==============================
func _iniciar_minijuego():
	if ui:
		ui.boton_anzuelo_on.disabled = true
		ui.boton_anzuelo_off.disabled = true

	# Ocultar botones mientras dura el minijuego
	_dump_estado("_iniciar_minijuego()")
	_ocultar_botones()
	if boton_subir: boton_subir.disabled = true
	if boton_bajar: boton_bajar.disabled = true
	if Tirar: Tirar.disabled = true
	print("🎣 Botón 'Lanzar' desactivado durante el minijuego.")

	# 🧩 Eliminar cualquier minijuego anterior para evitar duplicados
	if minijuego:
		if minijuego.is_connected("finalizado", Callable(self, "_on_minijuego_finalizado")):
			minijuego.disconnect("finalizado", Callable(self, "_on_minijuego_finalizado"))
		if is_instance_valid(minijuego):
			minijuego.queue_free()
		minijuego = null
		print("🧹 Minijuego anterior eliminado y desconectado.")

# 🎮 Crear uno nuevo
	minijuego = minijuego_escena.instantiate()
	get_tree().root.add_child(minijuego)
	
	if pez_atrapado:
		minijuego.get_node("Control").configurar_por_pez(pez_atrapado)

	var pescador = get_node_or_null("/root/MainJuego/Pescador")
	var caña = get_node_or_null("/root/MainJuego/Pescador/CañaPesca")
	Global.aplicar_efectos_caña(caña, self, pescador)
	caña.minijuego_activo = true


	# 🔒 Conexión única
	if not minijuego.is_connected("finalizado", Callable(self, "_on_minijuego_finalizado")):
		minijuego.connect("finalizado", Callable(self, "_on_minijuego_finalizado"))
		minijuego_conectado = true
	print("🎮 Minijuego iniciado desde el anzuelo (conexión única creada).")


	if caña:
		caña.minijuego_activo = true
		


func _on_minijuego_finalizado(resultado: bool):
	if ui:
		ui.boton_anzuelo_on.disabled = false
		ui.boton_anzuelo_off.disabled = false

	
	print("\n🧩 [DEBUG] Entró a _on_minijuego_finalizado()")
	print("   🔸 minijuego:", minijuego)
	print("   🔸 minijuego_conectado:", minijuego_conectado)
	print("   🔸 recogida_automatica_en_progreso:", recogida_automatica_en_progreso)
	print("   🔸 Estado actual:", estado if "estado" in self else "no definido")
	_dump_estado("_on_minijuego_finalizado:"+str(resultado))


	# 🔒 Evitar ejecuciones múltiples
	if recogida_automatica_en_progreso:
		print("⚠️ Ignorado: recogida automática ya en progreso.")
		return

	recogida_automatica_en_progreso = true
	print("🎮 Minijuego finalizado → Resultado:", resultado)

	if resultado:
		print("⚙️ [AUTO] Recogida automática iniciada por minijuego.")
		recogida_automatica_por_minijuego()
	else:
		print("❌ Falló — pez liberado.")
		if pez_atrapado:
			liberar_pez()
		_reset_ui_state()
		_restaurar_limites()
		var caña = get_node_or_null("/root/MainJuego/CañaPesca")
		if caña:
			caña.minijuego_activo = false
			caña.recogiendo = false
			caña.lanzado = false

	# 🔌 Desconexión segura del minijuego
	if minijuego:
		print("🧩 Intentando desconectar 'finalizado'...")
		if minijuego.is_connected("finalizado", Callable(self, "_on_minijuego_finalizado")):
			minijuego.disconnect("finalizado", Callable(self, "_on_minijuego_finalizado"))
			print("✅ Señal 'finalizado' desconectada correctamente.")
		else:
			print("⚠️ La señal ya no estaba conectada.")
		if is_instance_valid(minijuego):
			print("🧹 Eliminando instancia de minijuego...")
			minijuego.queue_free()
		else:
			print("⚠️ Instancia inválida, ya fue destruida.")
		minijuego = null
		minijuego_conectado = false
	else:
		print("⚠️ minijuego = null (no hay referencia).")

	recogida_automatica_en_progreso = false
	print("✅ [DEBUG] Salida normal de _on_minijuego_finalizado()\n")



# 💧 Detección de entrada al agua
func _on_area_entered(area):
	print("🌊 _on_area_entered() →", area.name)

	if not area.is_in_group("agua"):
		return

	if estado == Estado.RECOGIENDO or recogida_automatica:
		print("💧 IGNORADO por estado RECOGIENDO o recogida_automatica =", recogida_automatica)
		limite_superior = -INF
		limite_inferior = INF
		dentro_del_agua = false
		return

	print("🌊 Entra al agua con estado =", estado)
	en_transicion_caida = true
	dentro_del_agua = false
	puede_atrapar = false
	botones_mostrados = false
	botones_bloqueados = false
	tiempo_caida_actual = 0.0

	if area.is_in_group("agua"):
		await get_tree().process_frame  # 🔹 asegura que el frame siguiente tome el cambio
		gravedad = 300.0
		velocidad_anzuelo *= resistencia_agua
		print("💧 Físicas reducidas al entrar al agua (resistencia aplicada)")
		_dump_estado("_on_area_entered:"+area.name)



func _on_area_exited(area):
	print("🏝️ _on_area_exited() →", area.name)

	if not area.is_in_group("agua"):
		return

	# ⛔ Si estamos recogiendo (auto o manual), NO resetear nada aún.
	if estado == Estado.RECOGIENDO or recogida_automatica:
		print("[ANZUELO]_on_area_exited IGNORE RESET (recogiendo). " +
			"estado=", estado, " | pos=", position, " | objetivo=", posicion_inicial)
		# Sólo marcamos que ya no estamos en agua para que no se muestren botones y no frene la subida
		dentro_del_agua = false
		en_transicion_caida = false
		# Mantener límites infinitos mientras sube
		limite_superior = -INF
		limite_inferior = INF
		return

	# ✅ Caso normal (no recogiendo): restaurar
	print("🏖️ Salió del agua (estado =", estado, ") → restaurando límites base")
	_reset_ui_state()
	limite_superior = limite_superior_base
	limite_inferior = limite_inferior_base

	gravedad = 1200.0
	velocidad_anzuelo = Vector2.ZERO
	if caña:
		caña.gravedad = 1800.0

	print("☀️ Físicas restauradas al salir del agua (anzuelo y caña)")
	dentro_del_agua = false
	en_transicion_caida = false
	recogida_automatica = false
	recogida_automatica_en_progreso = false
	puede_atrapar = true
	print("🌞 Estado restaurado completamente al salir del agua.")


# 💧 Mostrar/Ocultar botones
func _mostrar_botones():
	if boton_subir and boton_bajar:
		boton_subir.visible = true
		boton_bajar.visible = true
		botones_mostrados = true
		print("⬆️⬇️ Botones visibles")

func _ocultar_botones():
	if boton_subir and boton_bajar:
		boton_subir.visible = false
		boton_bajar.visible = false
		botones_mostrados = false


# ⬆️⬇️ Movimiento manual con límites
func _subir_caña():
	if not dentro_del_agua:
		print("⚠️ No se puede subir, el anzuelo no está en el agua.")
		return
	subir_pulsado = true
	bajar_pulsado = false

func _bajar_caña():
	if not dentro_del_agua:
		print("⚠️ No se puede bajar, el anzuelo no está en el agua.")
		return
	bajar_pulsado = true
	subir_pulsado = false


		
		# 💧 Control de tiempo dentro del agua
func _comprobar_agua(delta):
	if dentro_del_agua:
		tiempo_en_agua += delta
		if tiempo_en_agua >= tiempo_necesario and not botones_mostrados:
			_mostrar_botones()
	else:
		tiempo_en_agua = 0.0
	
func _reset_ui_state():
	subir_pulsado = false
	bajar_pulsado = false
	botones_mostrados = false
	dentro_del_agua = false
	en_transicion_caida = false
	puede_atrapar = true
	if boton_subir:
		boton_subir.visible = false
		boton_subir.disabled = false
	if boton_bajar:
		boton_bajar.visible = false
		boton_bajar.disabled = false

func bloquear_por_minijuego():
	bloqueado_por_minijuego = true
	_ocultar_botones()
	if boton_subir: boton_subir.disabled = true
	if boton_bajar: boton_bajar.disabled = true
	_oscurecer_anzuelo()   # ← AÑADIR AQUÍ
	
func desbloquear_por_minijuego():
	bloqueado_por_minijuego = false
	_actualizar_estado_botones()
	_iluminar_anzuelo()

func recogida_automatica_por_minijuego():
	print("⚙️ [AUTO] Recogida automática iniciada por minijuego.")
	print("   - Estado actual:", estado)
	print("   - Dentro del agua:", dentro_del_agua)
	print("   - En transición caída:", en_transicion_caida)
	print("   - Posición inicial objetivo:", posicion_inicial)
	print("   - Posición actual:", position)

	recogida_automatica = true
	bloqueado_por_minijuego = true
	_desactivar_limites_temporal()
	estado = Estado.RECOGIENDO
	_oscurecer_anzuelo()   # ← AÑADIR AQUÍ
	dentro_del_agua = false
	en_transicion_caida = false
	puede_atrapar = false
	subir_pulsado = false
	bajar_pulsado = false

	if boton_subir: boton_subir.disabled = true
	if boton_bajar: boton_bajar.disabled = true
	if Tirar: Tirar.disabled = true

	set_process(true)
	set_physics_process(true)

	if posicion_inicial == Vector2.ZERO:
		posicion_inicial = position

	print("🎯 [AUTO] Iniciando subida hacia:", posicion_inicial)

	
# 🔧 Forzar reinicio limpio del anzuelo (por ejemplo si el jugador cancela pesca)
func forzar_recogida_manual():
	print("🔄 Forzando recogida manual del anzuelo")
	_desactivar_limites_temporal()
	recogida_automatica = true
	bloqueado_por_minijuego = true
	estado = Estado.RECOGIENDO
	subir_pulsado = false
	bajar_pulsado = false
	if boton_subir: boton_subir.disabled = true
	if boton_bajar: boton_bajar.disabled = true

# ==============================
#  LUZ CORRECTA PARA GODOT 4
# ==============================
func encender_luz_abisal():
	if luz_anzuelo:
		luz_anzuelo.energy = 2.0
		luz_anzuelo.color = Color(1.0, 1.0, 0.9)  # blanco cálido
		print("💡 [ANZUELO] Luz abisal ON (energy)")


func encender_luz_hadal():
	if luz_anzuelo:
		luz_anzuelo.energy = 5.0
		luz_anzuelo.color = Color(1.0, 1.0, 0.8)
		print("💡 [ANZUELO] Luz hadal ON (energy)")


func apagar_luz_superficial():
	if luz_anzuelo:
		luz_anzuelo.energy = 0.0
		print("💡 [ANZUELO] Luz OFF")

func _detectar_paredes():
	var pescador = get_node_or_null("/root/MainJuego/Pescador")

	var derecha: bool = ray_derecha.is_colliding()
	var izquierda: bool = ray_izquierda.is_colliding()
	var abajo: bool = ray_abajo.is_colliding()

	# ================================
	# LOG GENERAL DE DETECCIÓN
	# ================================
	print("🔍 _detectar_paredes() → D:", derecha, " | I:", izquierda, " | A:", abajo)

	# Si cualquier dirección detecta pared → bloqueo general
	bloqueado_por_pared = derecha or izquierda or abajo

	# ================================
	# BLOQUEO DE BAJAR
	# ================================
	if abajo:
		print("⛔ pared abajo detectada → no baja más")
		if boton_bajar:
			boton_bajar.disabled = true
	else:
		if boton_bajar and not bloqueado_por_minijuego:
			boton_bajar.disabled = false

	# ================================
	# BLOQUEO LATERAL DERECHO
	# ================================
	if derecha:

		print("⛔ pared derecha detectada")
		if pescador:
			pescador._bloquear_derecha = true
	else:
		if pescador:
			pescador._bloquear_derecha = false

	# ================================
	# BLOQUEO LATERAL IZQUIERDO
	# ================================
	if izquierda:

		print("⛔ pared izquierda detectada")
		if boton_bajar:
			boton_bajar.disabled = true
		if pescador:
			pescador._bloquear_izquierda = true
	else:
		if pescador:
			pescador._bloquear_izquierda = false

	print("🔍 FINAL → bloqueado_por_pared =", bloqueado_por_pared, " | bajar.disabled =", boton_bajar.disabled if boton_bajar else "N/A")

func _oscurecer_anzuelo():
	sprite.modulate = Color(0, 0, 0, 0.6)   # tono oscuro

func _iluminar_anzuelo():
	sprite.modulate = Color(1, 1, 1, 1)     # normal
