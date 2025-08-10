extends Control


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
	


func _on_optios_pressed() -> void:
	pass # Replace with function body.



func _on_salir_pressed() -> void:
	get_tree().quit()
