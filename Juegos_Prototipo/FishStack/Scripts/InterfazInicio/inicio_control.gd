extends Control

@export var origen := "inicio"   # Este menú SIEMPRE es origen "inicio"

func _ready():
	print("📁 IndexedDB habilitado:", JavaScriptBridge.eval("!!window.indexedDB"))
	print("[GODOT] Preparando recepción de userID...")

	JavaScriptBridge.eval("""
		window.sendUserIDToGodot = function(id) {
			console.log('[HTML Injection] sendUserIDToGodot recibió ID:', id);
			godot.runtime.call("recibir_user_id", id);
		};
	""")

func recibir_user_id(id):
	print("📩 UserID recibido desde JS:", id)
	Global.guardar_progreso_en_server(id)

func _on_jugar_pressed() -> void:
	get_tree().change_scene_to_file("res://Scene/main_juego.tscn")


func _on_opcion_pressed() -> void:
	var opciones = load("res://Scene/MenuOpciones.tscn").instantiate()
	opciones.origen = "inicio"  # ← IMPORTANTE
	get_tree().root.add_child(opciones)



func _on_salir_pressed() -> void:
	get_tree().quit()
