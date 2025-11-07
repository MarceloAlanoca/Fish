extends Node2D

func _ready():
	# 1) cargar equipados desde disco a Global
	Global.cargar_amuletos()

	# 2) aplicar efectos al Pescador
	var pescador := get_node_or_null("Pescador")
	if pescador:
		Global.reaplicar_efectos_pescador(pescador)
	else:
		push_warning("⚠️ No se encontró 'Pescador' en MainJuego")
		
