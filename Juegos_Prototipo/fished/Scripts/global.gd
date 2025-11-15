extends Node

var MODO_DESARROLLO := true

# =======================================
# VARIABLES GLOBALES
# =======================================
var doblones: int = 100000
var amuletos_comprados: Array = []
var amuletos_equipados: Array = []
var cañas_compradas: Array = []
var caña_equipada: String = ""  # nombre de la caña equipada actualmente

const RUTA_CAÑAS := {
	"Caña de Madera Fuerte": "res://Assets/Cañas/cañaT1.png",
	"Caña de Mango Grande": "res://Assets/Cañas/cañaT2.png",
	"Caña de Acero": "res://Assets/Cañas/cañaT3.png",
	"Caña Épica": "res://Assets/Cañas/cañaT4.png",
	"Caña Legendaria": "res://Assets/Cañas/cañaT5.png"
}
var caña_sprite_path: String = ""  # 🔁 textura de la caña equipada

func _ready():
	if MODO_DESARROLLO and FileAccess.file_exists("user://fishstack_save.json"):
		DirAccess.remove_absolute("user://fishstack_save.json")
		print("🧹 Archivo reiniciado (modo desarrollo).")

	cargar_cañas()



# ====================================================
# 💾 GUARDAR / CARGAR AMULETOS EQUIPADOS
# ====================================================

var save_path := "user://amuletos_guardados.save"

func cargar_amuletos():
	var data := Save.cargar_datos()
	amuletos_comprados = data.get("amuletos", [])
	amuletos_equipados = data.get("equipados", [])

func guardar_amuletos():
	var data := Save.cargar_datos()
	data["amuletos"] = amuletos_comprados
	data["equipados"] = amuletos_equipados
	data["doblones"] = doblones
	Save.guardar_datos(data)

# ——— helpers para aplicar efectos sin “stackearlos” ———

func _preparar_base_pescador(pescador: Node) -> void:
	if not pescador:
		return
	# 💾 Solo guarda la base UNA VEZ: nunca la pisa después
	if not pescador.has_meta("vel_base"):
		pescador.set_meta("vel_base", pescador.velocidad)
	if not pescador.has_meta("multi_base"):
		pescador.set_meta("multi_base", pescador.multiplicador_velocidad_pesca)



func reaplicar_efectos_pescador(pescador: Node) -> void:
	if not pescador:
		return

	# 🧱 Si no hay base guardada, la crea una vez
	_preparar_base_pescador(pescador)

	# 🔁 Restaurar valores originales antes de aplicar nada
	pescador.velocidad = float(pescador.get_meta("vel_base"))
	pescador.multiplicador_velocidad_pesca = float(pescador.get_meta("multi_base"))

	# ⚙️ Aplicar efectos actuales desde cero (sin acumular)
	aplicar_efectos_pescador(pescador)

# =======================================
# 💎 EFECTOS DE AMULETOS REALES
# =======================================

# ————————————————
# 🎣 PESCADOR
# ————————————————
func aplicar_efectos_pescador(pescador: Node) -> void:
	if not pescador:
		return

	var base_vel: float = float(pescador.get_meta("vel_base"))
	var base_mult: float = float(pescador.get_meta("multi_base"))

	var nueva_vel: float = base_vel
	var nuevo_mult: float = base_mult

	# ✅ Amuleto Raro → +50% velocidad y penalización pesca mínima
	if "Amuleto Raro" in amuletos_equipados:
		nueva_vel *= 1.5
		nuevo_mult = max(nuevo_mult, 0.55)
		print("⚙️ Amuleto Raro aplicado → Vel:", nueva_vel, "Mult:", nuevo_mult)

	# ✅ Amuleto Celestial → +25% velocidad general
	if "Amuleto Celestial" in amuletos_equipados:
		nueva_vel *= 1.25
		print("⚙️ Amuleto Celestial aplicado → Vel:", nueva_vel)

	# 🔹 Guardar resultado final sin modificar la base
	pescador.velocidad = nueva_vel
	pescador.multiplicador_velocidad_pesca = nuevo_mult



	# Amuleto Exótico → reduce velocidad en minijuego (35%) → se maneja en minijuego
	# Amuleto Dineral → efectos de dinero se manejan en LibOCap


# ————————————————
# 🪝 ANZUELO
# ————————————————
func aplicar_efectos_anzuelo(anzuelo: Node) -> void:
	if not anzuelo:
		return

	if not anzuelo.has_meta("modificador_probabilidad"):
		anzuelo.set("modificador_probabilidad", 1.0)
	else:
		anzuelo.modificador_probabilidad = 1.0


	# Amuleto Exótico → +20% probabilidad general
	if "Amuleto Exotico" in amuletos_equipados:
		anzuelo.modificador_probabilidad *= 1.2

	# Amuleto Secreto → +45% suerte durante la noche
	if "Amuleto Secreto" in amuletos_equipados:
		var hora = Time.get_time_dict_from_system().hour
		if hora >= 20 or hora <= 6:  # modo "de noche"
			anzuelo.modificador_probabilidad *= 1.45
		else:
			anzuelo.modificador_probabilidad *= 1.2  # base de día


# ————————————————
# 🎮 MINIJUEGO
# ————————————————
func aplicar_efectos_minijuego(minijuego: Node) -> void:
	if not minijuego:
		return

	# Amuleto Común → -10% resiliencia = el pez se mueve más suave
	if "Amuleto Común" in amuletos_equipados and "resiliencia" in minijuego:
		minijuego.resiliencia *= 0.9

	# Amuleto Celestial → resiliencia -25% (pez más predecible)
	if "Amuleto Celestial" in amuletos_equipados and "resiliencia" in minijuego:
		minijuego.resiliencia *= 0.75

	# Amuleto Exótico → -35% velocidad pez y jugador en minijuego
	if "Amuleto Exotico" in amuletos_equipados:
		if "velocidad_pez" in minijuego:
			minijuego.velocidad_pez *= 0.65
		if "velocidad_jugador" in minijuego:
			minijuego.velocidad_jugador *= 0.65

	# Amuleto Secreto → duplica zona del jugador + 20% progreso + 45% suerte si es de noche
	if "Amuleto Secreto" in amuletos_equipados:
		if "rango_colision" in minijuego:
			minijuego.rango_colision *= 2
		if "progreso_subida" in minijuego:
			minijuego.progreso_subida *= 1.2

		var hora = Time.get_time_dict_from_system().hour
		if hora >= 20 or hora <= 6:
			if "progreso_subida" in minijuego:
				minijuego.progreso_subida *= 1.45


# ————————————————
# 💰 GANANCIAS (LibOCap)
# ————————————————
func aplicar_efectos_ganancia(valor: int) -> int:
	var resultado = valor

	# Amuleto Dineral → X2 ganancia + 25% chance de bono 500
	if "Amuleto Dineral" in amuletos_equipados:
		resultado *= 2
		if randf() <= 0.25:
			resultado += 500

	return resultado
	
# # =======================================
# 🎣 EFECTOS DE CAÑAS — APLICADOS A CAÑA Y ANZUELO + SPRITE
# =======================================
func aplicar_efectos_caña(caña: Node, anzuelo: Node, pescador: Node = null, minijuego: Node = null) -> void:
	if not caña or not anzuelo:
		return

	# 🔁 Guardar valores base solo la primera vez
	if not anzuelo.has_meta("vel_base"):
		anzuelo.set_meta("vel_base", anzuelo.velocidad_recogida_manual)
	if not anzuelo.has_meta("vel_vertical_base"):
		anzuelo.set_meta("vel_vertical_base", anzuelo.velocidad_vertical)
	if not anzuelo.has_meta("limite_inferior_base"):
		anzuelo.set_meta("limite_inferior_base", anzuelo.limite_inferior_base)
	if not caña.has_meta("fuerza_base"):
		caña.set_meta("fuerza_base", caña.fuerza_lanzamiento)
	if minijuego and not minijuego.has_meta("resiliencia_base"):
		minijuego.set_meta("resiliencia_base", minijuego.resiliencia)

	# 🔄 Restaurar valores base
	anzuelo.velocidad_recogida_manual = anzuelo.get_meta("vel_base")
	anzuelo.velocidad_vertical = anzuelo.get_meta("vel_vertical_base")
	anzuelo.limite_inferior_base = anzuelo.get_meta("limite_inferior_base")
	caña.fuerza_lanzamiento = caña.get_meta("fuerza_base")
	if minijuego:
		minijuego.resiliencia = minijuego.get_meta("resiliencia_base")

	# =======================================================
	# ⚙️ Aplicar efectos progresivos por tipo de caña
	# =======================================================
	match caña_equipada:
		"Caña de Madera Fuerte":
			# Caña básica → poca profundidad y rebote normal
			anzuelo.limite_inferior_base = 200.0 + 6.5
			anzuelo.gravedad = 1200.0
			if minijuego:
				minijuego.resiliencia *= 1.0
			_actualizar_sprite_caña(pescador, RUTA_CAÑAS["Caña de Madera Fuerte"])

		"Caña de Mango Grande":
			# Un poco más profunda, menos freno al tocar el agua
			anzuelo.velocidad_recogida_manual *= 1.15
			anzuelo.velocidad_vertical *= 1.15
			anzuelo.gravedad = 1000.0
			anzuelo.limite_inferior_base = 922.50 + 6.5
			if minijuego:
				minijuego.resiliencia *= 0.95
			_actualizar_sprite_caña(pescador, RUTA_CAÑAS["Caña de Mango Grande"])

		"Caña de Acero":
			# Ideal para media profundidad, 45%+ recogida
			anzuelo.velocidad_recogida_manual *= 1.3
			anzuelo.velocidad_vertical *= 1.3
			caña.fuerza_lanzamiento *= 1.5
			anzuelo.gravedad = 800.0  # menos rebote
			anzuelo.limite_inferior_base = 3050.0 + 6.5
			if minijuego:
				minijuego.resiliencia *= 1
			_actualizar_sprite_caña(pescador, RUTA_CAÑAS["Caña de Acero"])

		"Caña Épica":
			# Muy profunda, casi sin rebote al agua
			anzuelo.velocidad_recogida_manual *= 1.45
			anzuelo.velocidad_vertical *= 1.4
			caña.fuerza_lanzamiento *= 1.15
			anzuelo.gravedad = 600.0
			anzuelo.limite_inferior_base = 5180.0 + 6.5
			if minijuego:
				minijuego.resiliencia *= 0.85
			_actualizar_sprite_caña(pescador, RUTA_CAÑAS["Caña Épica"])

		"Caña Legendaria":
			# Máxima profundidad, movimiento fluido y rebote casi nulo
			anzuelo.velocidad_recogida_manual *= 5
			anzuelo.velocidad_vertical *= 5
			caña.fuerza_lanzamiento *= 2
			anzuelo.gravedad = 400.0
			anzuelo.limite_inferior_base = 25000.0
			if minijuego:
				minijuego.resiliencia *= 0.8
			_actualizar_sprite_caña(pescador, RUTA_CAÑAS["Caña Legendaria"])
			
		# ✅ Asegurar que los límites activos del anzuelo coincidan con los nuevos base
	# 🟢 Actualizar límites activos del anzuelo
	anzuelo.limite_superior = anzuelo.limite_superior_base
	anzuelo.limite_inferior = anzuelo.limite_inferior_base

	print("🎣 Efectos aplicados →", caña_equipada)
	print("   ⚙️ gravedad:", anzuelo.gravedad,
		  " | recogida:", anzuelo.velocidad_recogida_manual,
		  " | vertical:", anzuelo.velocidad_vertical,
		  " | límite:", anzuelo.limite_inferior_base)
	
	

		
func _actualizar_sprite_caña(pescador: Node, textura_path: String) -> void:
	if not pescador:
		return

	var sprite := pescador.get_node_or_null("CañaPesca/Caña/Sprite2D")
	if sprite:
		sprite.texture = load(textura_path)
		print("🎨 Sprite de caña actualizado correctamente:", textura_path)
	else:
		push_warning("⚠️ No se encontró el sprite de la caña (CañaPesca/Caña/Sprite2D)")

# ====================================================
# 💾 GUARDAR / CARGAR CAÑAS COMPRADAS Y EQUIPADA
# ====================================================

func cargar_cañas():
	var data := Save.cargar_datos()
	cañas_compradas = data.get("cañas", [])
	caña_equipada = data.get("caña_equipada", "")
	caña_sprite_path = data.get("caña_sprite", "")

	if cañas_compradas.is_empty():
		cañas_compradas.append("Caña de Madera Fuerte")

	if caña_equipada == "" or not (caña_equipada in cañas_compradas):
		caña_equipada = "Caña de Madera Fuerte"

	# 🔁 Asegura que la textura coincida con la caña equipada
	if RUTA_CAÑAS.has(caña_equipada):
		caña_sprite_path = RUTA_CAÑAS[caña_equipada]
	else:
		caña_sprite_path = "res://Assets/Cañas/cañaT1.png"

	print("🎣 Caña cargada:", caña_equipada, "| sprite:", caña_sprite_path)



func guardar_cañas():
	# 🧩 Asegura que la ruta del sprite corresponda a la caña actual
	if RUTA_CAÑAS.has(caña_equipada):
		caña_sprite_path = RUTA_CAÑAS[caña_equipada]
	else:
		caña_sprite_path = "res://Assets/Cañas/cañaT1.png"  # fallback seguro

	var data := Save.cargar_datos()
	data["cañas"] = cañas_compradas
	data["caña_equipada"] = caña_equipada
	data["caña_sprite"] = caña_sprite_path
	data["doblones"] = doblones
	Save.guardar_datos(data)
	print("💾 Guardado:", caña_equipada, "| sprite:", caña_sprite_path)


# Aplica el sprite guardado cuando el jugador vuelve al juego
func aplicar_sprite_guardado(pescador: Node):
	if not pescador:
		return
	var sprite := pescador.get_node_or_null("CañaPesca/Caña/Sprite2D")
	if sprite and caña_sprite_path != "":
		sprite.texture = load(caña_sprite_path)
		print("🎨 Sprite reaplicado desde guardado:", caña_sprite_path)
