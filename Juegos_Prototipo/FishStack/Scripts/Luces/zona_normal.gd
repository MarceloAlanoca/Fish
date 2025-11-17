extends Area2D

func _on_zona_normal_area_entered(area):
	if area.name == "Anzuelo":
		print("☀️ ENTRÓ A ZONA NORMAL (Area)")
		get_parent().set_luz_superficial()
