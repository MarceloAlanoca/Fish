extends Node

var MODO_DESARROLLO := false
# =======================================
# VARIABLES GLOBALES
# =======================================
var doblones: int = 100
var amuletos_comprados: Array = []
var amuletos_equipados: Array = []
var canas_compradas: Array = []
var cana_equipada: String = ""  # nombre de la caña equipada actualmente
var barcos_comprados: Array = []
var barco_equipado: String = ""  # 🟢 Barco actual

const RUTA_CAÑAS := {
	"Caña de Madera Fuerte": "res://Assets/Cañas/cañaT1.png",
	"Caña de Mango Grande": "res://Assets/Cañas/cañaT2.png",
	"Caña de Acero": "res://Assets/Cañas/cañaT3.png",
	"Caña Épica": "res://Assets/Cañas/cañaT4.png",
	"Caña Legendaria": "res://Assets/Cañas/cañaT5.png"
}
var caña_sprite_path: String = ""  # 🔁 textura de la caña equipada

# ====================================================
# 🚤 BARCOS
# ====================================================
const RUTA_BARCOS := {
	"Bote Chico": "res://Assets/Barcos/barcoT1.png",
	"Velero Rojo": "res://Assets/Barcos/barcoT2.png",
	"Lancha Veloz": "res://Assets/Barcos/barcoT3.png",
	"Barco Pesquero": "res://Assets/Barcos/barcoT4.png",
	"Buque Marino": "res://Assets/Barcos/barcoT5.png"
}

const POS_CAÑAPESCA := {
	"Bote Chico": Vector2(71, -35),
	"Velero Rojo": Vector2(70, -35),
	"Lancha Veloz": Vector2(70, -34),
	"Barco Pesquero": Vector2(118, -41),
	"Buque Marino": Vector2(99, -7)
}


# =======================================
# 🎭 SKINS DEL PESCADOR
# =======================================
var skins_comprados: Array = []
var skin_equipada: String = "George"   # skin por defecto

const RUTA_SKINS := {
	"George": "res://Assets/Skines/Skin0.png",
	"Privilegeado": "res://Assets/Skines/Skin1.png",
	"Verano": "res://Assets/Skines/Skin2.png",
	"Eggman": "res://Assets/Skines/Skin3.png",
	"Gru": "res://Assets/Skines/Skin4.png",
	"Mafia": "res://Assets/Skines/Skin5.png"
}

# =======================================
# 🧍 POSICIONES DE GEORGE SEGÚN EL BARCO
# =======================================
const POS_GEORGE := {
	"Bote Chico": { 
		"left": Vector2(-20, -18), 
		"right": Vector2(20, -18),
		"scale": Vector2(1.63, 1.28) 
	},

	"Velero Rojo": { 
		"left": Vector2(25, -12), 
		"right": Vector2(-25, -12),
		"scale": Vector2(1.63, 1.28)
	},

	"Lancha Veloz": { 
		"left": Vector2(-20, -10), 
		"right": Vector2(20, -10),
		"scale": Vector2(1.63, 1.28)
	},

	"Barco Pesquero": { 
		"left": Vector2(80, -19), 
		"right": Vector2(-80, -19),
		"scale": Vector2(1.63, 1.28)
	},

	"Buque Marino": { 
		"left": Vector2(-80, 1), 
		"right": Vector2(80, 1),
		"scale": Vector2(1.63, 1.28) / 1.2
	}
}

# ================================
# 🔱 SISTEMA DE ALINEACIONES (POSEIDÓN)
# ================================
var alineaciones_compradas: Array = []
var alineacion_equipada: String = ""  # Ninguna al inicio

# Estado para saber si la tienda está desbloqueada
var tienda_poseidon_desbloqueada: bool = true

func _ready():
	if MODO_DESARROLLO:
		if FileAccess.file_exists("user://fishstack_save.json"):
				DirAccess.remove_absolute("user://fishstack_save.json")
		if FileAccess.file_exists("user://amuletos_guardados.save"):
				DirAccess.remove_absolute("user://amuletos_guardados.save")
		print("🧹 Archivos reiniciados (modo desarrollo).")

	cargar_doblones()
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

	# Si NO existe vel_base o es null → guardarla
	if not pescador.has_meta("vel_base") or pescador.get_meta("vel_base") == null:
		pescador.set_meta("vel_base", float(pescador.velocidad))
		print("💾 Base GUARDADA vel_base =", pescador.velocidad)

	# Si NO existe multi_base o es null → guardarla
	if not pescador.has_meta("multi_base") or pescador.get_meta("multi_base") == null:
		pescador.set_meta("multi_base", float(pescador.multiplicador_velocidad_pesca))
		print("💾 Base GUARDADA multi_base =", pescador.multiplicador_velocidad_pesca)



@warning_ignore("shadowed_variable")
func reaplicar_efectos_pescador(pescador: Node, aplicar_barco := false) -> void:
	if not pescador:
		return

	# -----------------------------
	# 1) LEER METAS (si existen)
	# -----------------------------
	var vel_meta = null
	var multi_meta = null

	if pescador.has_meta("vel_base"):
		vel_meta = pescador.get_meta("vel_base")

	if pescador.has_meta("multi_base"):
		multi_meta = pescador.get_meta("multi_base")

	# -----------------------------
	# 2) SI NO EXISTEN, CREARLAS
	# -----------------------------
	if vel_meta == null or multi_meta == null:
		var vel_actual: float = float(pescador.velocidad)
		var multi_actual: float = float(pescador.multiplicador_velocidad_pesca)

		pescador.set_meta("vel_base", vel_actual)
		pescador.set_meta("multi_base", multi_actual)

		vel_meta = vel_actual
		multi_meta = multi_actual

		print("⚠️ BASES GENERADAS (eran null): vel =", vel_meta, " mult =", multi_meta)
	else:
		print("✅ BASES RECUPERADAS: vel =", vel_meta, " mult =", multi_meta)

	# -----------------------------
	# 3) Restaurar valores base 
	# -----------------------------
	pescador.velocidad = float(vel_meta)
	pescador.multiplicador_velocidad_pesca = float(multi_meta)

	# -----------------------------
	# 4) Aplicar efectos de amuletos
	# -----------------------------
	aplicar_efectos_pescador(pescador)

	# -----------------------------
	# 5) Aplicar barco al final
	# -----------------------------
	if aplicar_barco and barco_equipado != "":
		aplicar_barco(pescador)




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

	# ==================================================
	# 💎 Amuleto Dineral → X2 ganancia + chance de bono
	# ==================================================
	if "Amuleto Dineral" in amuletos_equipados:
		resultado *= 2
		if randf() <= 0.25:
			resultado += 500

	# ==============================
	# 🚤 Bonus por barco equipado
	# ==============================
	match barco_equipado:
		"Barco Pesquero":
			resultado = int(resultado * 1.10)  # +10% ganancias

		"Buque Marino":
			resultado = int(resultado * 1.25)  # +25% ganancias

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
	match cana_equipada:
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

	print("🎣 Efectos aplicados →", cana_equipada)
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
	canas_compradas = data.get("cañas", [])
	cana_equipada = data.get("cana_equipada", "")
	caña_sprite_path = data.get("caña_sprite", "")

	if canas_compradas.is_empty():
		canas_compradas.append("Caña de Madera Fuerte")

	if cana_equipada == "" or not (cana_equipada in canas_compradas):
		cana_equipada = "Caña de Madera Fuerte"

	# 🔁 Asegura que la textura coincida con la caña equipada
	if RUTA_CAÑAS.has(cana_equipada):
		caña_sprite_path = RUTA_CAÑAS[cana_equipada]
	else:
		caña_sprite_path = "res://Assets/Cañas/cañaT1.png"

	print("🎣 Caña cargada:", cana_equipada, "| sprite:", caña_sprite_path)



func guardar_cañas():
	# 🧩 Asegura que la ruta del sprite corresponda a la caña actual
	if RUTA_CAÑAS.has(cana_equipada):
		caña_sprite_path = RUTA_CAÑAS[cana_equipada]
	else:
		caña_sprite_path = "res://Assets/Cañas/cañaT1.png"  # fallback seguro

	var data := Save.cargar_datos()
	data["cañas"] = canas_compradas
	data["caña_equipada"] = cana_equipada
	data["caña_sprite"] = caña_sprite_path
	data["doblones"] = doblones
	Save.guardar_datos(data)
	print("💾 Guardado:", cana_equipada, "| sprite:", caña_sprite_path)


# Aplica el sprite guardado cuando el jugador vuelve al juego
func aplicar_sprite_guardado(pescador: Node):
	if not pescador:
		return
	var sprite := pescador.get_node_or_null("CañaPesca/Caña/Sprite2D")
	if sprite and caña_sprite_path != "":
		sprite.texture = load(caña_sprite_path)
		print("🎨 Sprite reaplicado desde guardado:", caña_sprite_path)


# ====================================================
# 💾 GUARDAR / CARGAR BARCOS COMPRADOS
# ====================================================

func cargar_barcos():
	var data := Save.cargar_datos()
	barcos_comprados = data.get("barcos", [])

func guardar_barcos():
	var data := Save.cargar_datos()
	data["barcos"] = barcos_comprados
	data["doblones"] = doblones
	Save.guardar_datos(data)
	
func cargar_barco_equipado():
	var data = Save.cargar_datos()
	barco_equipado = data.get("barco_equipado", "")

	# Si no existe aún, poner el barco inicial
	if barco_equipado == "" or not (barco_equipado in barcos_comprados):
		barco_equipado = "Bote Chico"


func guardar_barco_equipado():
	var data := Save.cargar_datos()
	data["barco_equipado"] = barco_equipado
	Save.guardar_datos(data)

#Aplicacion de efectos

func aplicar_barco(pescador: Node):
	# Guardar la posición base REAL la primera vez
	if not pescador:
		return

	# Guardar la posición base REAL la primera vez
	if not pescador.has_meta("pos_y_real_base") or pescador.get_meta("pos_y_real_base") == null:
		pescador.set_meta("pos_y_real_base", pescador.global_position.y)


		
	# Guardar la posición base del pescador UNA SOLA VEZ
	var base = pescador.get_meta("pos_y_real_base")
	var base_y = base + 5
	
	# 1) Sprite del barco
	var sprite = pescador.get_node_or_null("Sprite2D")
	if sprite and RUTA_BARCOS.has(barco_equipado):
		sprite.texture = load(RUTA_BARCOS[barco_equipado])

	# 2) Posición de la caña
	var cp = pescador.get_node_or_null("CañaPesca")
	if cp and POS_CAÑAPESCA.has(barco_equipado):
		cp.position = POS_CAÑAPESCA[barco_equipado]

	# 3) Efectos numéricos
	var base_vel: float = float(pescador.velocidad)
	var base_mult: float = float(pescador.multiplicador_velocidad_pesca)

	match barco_equipado:
		"Bote Chico":
			pescador.velocidad = base_vel
			pescador.multiplicador_velocidad_pesca = base_mult

		"Velero Rojo": # 👈 corregido el nombre, igual que en la tienda
			pescador.velocidad = base_vel * 1.20
			pescador.multiplicador_velocidad_pesca = max(base_mult, 0.10)

		"Lancha Veloz":
			pescador.velocidad = base_vel * 1.40
			pescador.multiplicador_velocidad_pesca = max(base_mult, 0.20)

		"Barco Pesquero":
			pescador.velocidad = base_vel * 1.60
			pescador.multiplicador_velocidad_pesca = max(base_mult, 0.30)

		"Buque Marino":
			pescador.velocidad = base_vel * 1.85
			pescador.multiplicador_velocidad_pesca = max(base_mult, 0.40)

	print("🚤 [BARCO]", barco_equipado,
		" | vel =", pescador.velocidad,
		" | mult_pesca =", pescador.multiplicador_velocidad_pesca)
		
		# 4) Reposicionar anzuelo y resetear su origen
	var anzuelo := pescador.get_node_or_null("CañaPesca/Caña/Anzuelo")
	if anzuelo:
		# moverlo exactamente a donde lo tiene la caña nueva
		anzuelo.position = anzuelo.posicion_inicial
		
		# actualizar la posición inicial REAL
		anzuelo.posicion_inicial = anzuelo.position

		# Resetear estados para que NO se quede “tirado”
		anzuelo.estado = anzuelo.Estado.INACTIVO
		anzuelo.velocidad_anzuelo = Vector2.ZERO
		anzuelo.recogida_automatica = false
		anzuelo.en_transicion_caida = false
		anzuelo.dentro_del_agua = false
		
		
	if barco_equipado == "Buque Marino":
		pescador.position.y = base_y - 75
	else:
		pescador.position.y = base_y

		
		
# ====================================================
# 💾 GUARDAR / CARGAR Disfrazes COMPRADOS
# ====================================================

func guardar_skins():
	var data := Save.cargar_datos()
	data["skins"] = skins_comprados
	data["skin_equipada"] = skin_equipada
	data["doblones"] = doblones
	Save.guardar_datos(data)

func cargar_skins():
	var data := Save.cargar_datos()

	skins_comprados = data.get("skins", [])
	skin_equipada = data.get("skin_equipada", "George")

	if skins_comprados.is_empty():
		skins_comprados.append("George")

	if not (skin_equipada in skins_comprados):
		skin_equipada = "George"

func aplicar_skin(pescador: Node):
	if not pescador:
		return

	var sprite := pescador.get_node_or_null("George")
	if sprite and RUTA_SKINS.has(skin_equipada):
		sprite.texture = load(RUTA_SKINS[skin_equipada])
		print("🎭 Skin aplicada:", skin_equipada)
		
# ====================================================
# 💾 GUARDAR / CARGAR Alineaciones COMPRADOS
# ====================================================

func guardar_alineaciones():
	var data := Save.cargar_datos()
	data["alineaciones"] = alineaciones_compradas
	data["alineacion_equipada"] = alineacion_equipada
	Save.guardar_datos(data)

func cargar_alineaciones():
	var data := Save.cargar_datos()
	
	alineaciones_compradas = data.get("alineaciones", [])
	alineacion_equipada = data.get("alineacion_equipada", "")

	# Al menos una alineación debe existir (si querés)
	if alineaciones_compradas.is_empty():
		alineaciones_compradas.append("Alineación Azul") # ejemplo
		if alineacion_equipada == "":
			alineacion_equipada = "Alineación Azul"
			
func guardar_poseidon():
	var data := Save.cargar_datos()
	data["poseidon"] = tienda_poseidon_desbloqueada
	Save.guardar_datos(data)

func cargar_poseidon():
	var data := Save.cargar_datos()
	tienda_poseidon_desbloqueada = data.get("poseidon", false)
	


func guardar_progreso_en_server(user_id):
	var url = "http://localhost/Fish/Proyecto_General/FuncionesPHP/FishStack.php"

	var datos = {
		"user_id": user_id,
		"doblones": doblones,
		"amuletos": amuletos_comprados,
		"equipados": amuletos_equipados,
		"canas": canas_compradas,
		"barcos": barcos_comprados,
		"barcos_comprados": barcos_comprados,  # ← FIX
		"barco_equipado": barco_equipado,
		"skins": skins_comprados,
		"skin_equipada": skin_equipada,
		"alineaciones": alineaciones_compradas,
		"alineacion_equipada": alineacion_equipada
	}


	var http := HTTPRequest.new()
	add_child(http)

	http.request(
		url,
		["Content-Type: application/json"],
		HTTPClient.METHOD_POST,
		JSON.stringify(datos)
	)
	
	http.request_completed.connect(func(result, response_code, headers, body):
		print("[SERVER] Código:", response_code)
		print("[SERVER] Respuesta:", body.get_string_from_utf8())
	)

func cargar_doblones():
	var data := Save.cargar_datos()
	doblones = data.get("doblones", doblones)

	print("💰 Doblones cargados:", doblones)
	
func guardar_doblones():
	var data := Save.cargar_datos()
	data["doblones"] = doblones
	Save.guardar_datos(data)
	print("💾 Doblones guardados:", doblones)
