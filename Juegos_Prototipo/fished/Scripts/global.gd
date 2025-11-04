extends Node

# =======================================
# VARIABLES GLOBALES
# =======================================
var doblones: int = 100
var amuletos_comprados: Array = []
var amuletos_equipados: Array = []

# =======================================
# 💎 EFECTOS DE AMULETOS REALES
# =======================================

# ————————————————
# 🎣 PESCADOR
# ————————————————
func aplicar_efectos_pescador(pescador: Node) -> void:
	if not pescador:
		return

	# Amuleto Raro → +50% velocidad de movimiento
	if "Amuleto Raro" in amuletos_equipados:
		pescador.velocidad *= 1.5

	# Amuleto Celestial → +25% velocidad pasiva (barco/pescador general)
	if "Amuleto Celestial" in amuletos_equipados:
		pescador.velocidad *= 1.25

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
