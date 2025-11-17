extends Area2D

func _on_zona_abisal_area_entered(area: Area2D) -> void:
	if area.name != "Anzuelo":
		return

	print("➡️ ENTRÓ ABISAL")

	var main := get_parent()
	main.set_luz_abisal()

	if area.has_method("encender_luz_abisal"):
		area.encender_luz_abisal()


func _on_zona_abisal_area_exited(area: Area2D) -> void:
	if area.name != "Anzuelo":
		return

	print("⬅️ SALIÓ ABISAL")

	# comprobar si sigue en hadal
	var hadal := get_parent().get_node("ZonaHadal")
	if hadal and hadal.get_overlapping_areas().has(area):
		return

	var main := get_parent()
	main.set_luz_superficial()

	if area.has_method("apagar_luz_superficial"):
		area.apagar_luz_superficial()
