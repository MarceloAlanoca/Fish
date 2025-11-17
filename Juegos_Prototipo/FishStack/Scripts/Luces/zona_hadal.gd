extends Area2D

func _on_zona_hadal_area_entered(area: Area2D) -> void:
	if area.name != "Anzuelo":
		return

	print("⬇️ Entró a HADAL:", area.name)

	get_parent().set_luz_hadal()            # luz global
	if area.has_method("encender_luz_hadal"):
		area.encender_luz_hadal()           # luz anzuelo


func _on_zona_hadal_area_exited(area: Area2D) -> void:
	if area.name != "Anzuelo":
		return

	# Si sigue en Abisal → luz abisal
	var abisal := get_parent().get_node("ZonaAbisal")
	if abisal and abisal.get_overlapping_areas().has(area):
		get_parent().set_luz_abisal()
		if area.has_method("encender_luz_abisal"):
			area.encender_luz_abisal()
		return

	# Si no está en ninguna → superficie
	get_parent().set_luz_superficial()
	if area.has_method("apagar_luz_superficial"):
		area.apagar_luz_superficial()
