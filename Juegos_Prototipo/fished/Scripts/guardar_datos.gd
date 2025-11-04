extends Node

const FILE_PATH = "user://fishstack_save.json"

func guardar_datos(datos: Dictionary):
	var file = FileAccess.open(FILE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(datos))
	file.close()

func cargar_datos() -> Dictionary:
	if not FileAccess.file_exists(FILE_PATH):
		return {
			"doblones": 0,
			"amuletos": [],
			"equipados": []
		}
	var file = FileAccess.open(FILE_PATH, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	return JSON.parse_string(content)
