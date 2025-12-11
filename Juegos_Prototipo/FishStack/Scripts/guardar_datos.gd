extends Node

const FILE_PATH = "user://fishstack_save.json"

func guardar_datos(datos: Dictionary):
	var file = FileAccess.open(FILE_PATH, FileAccess.WRITE)

	if file == null:
		push_error("❌ No se pudo escribir en " + FILE_PATH + " | Error: " + str(FileAccess.get_open_error()))
		return

	file.store_string(JSON.stringify(datos))
	file.close()
	print("💾 Guardado OK en:", FILE_PATH)

func cargar_datos() -> Dictionary:
	if not FileAccess.file_exists(FILE_PATH):
		print("⚠️ Archivo no existe, creando nuevo.")
		return {
			"doblones": 100,
			"amuletos": [],
			"equipados": []
		}

	var file = FileAccess.open(FILE_PATH, FileAccess.READ)

	if file == null:
		push_error("❌ No se pudo leer archivo | Error: " + str(FileAccess.get_open_error()))
		return {}

	var content = file.get_as_text()
	file.close()
	print("📂 Datos cargados desde:", FILE_PATH)
	return JSON.parse_string(content)
