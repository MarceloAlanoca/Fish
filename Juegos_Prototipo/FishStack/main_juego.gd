extends Node2D

@onready var world_env: Environment = $WorldEnvironment.environment
@onready var canvas_modulate := $CanvasModulate

func _ready():
	print("🌐 Plataforma:", OS.get_name())
	print("📁 user:// path real:", ProjectSettings.globalize_path("user://"))
	var pescador = $Pescador
	Global.aplicar_sprite_guardado(pescador)
	Global.cargar_amuletos()
	set_luz_superficial()  # luz inicial

# ============================
# ⭐ SISTEMA DE TRANSICIÓN DE LUZ
# ============================

var tween_luz: Tween

func _transicionar_luz(exposure_objetivo: float, color_objetivo: Color, duracion := 0.8):
	# Cancelar transición anterior si existe
	if tween_luz:
		tween_luz.kill()

	# Crear nuevo Tween
	tween_luz = get_tree().create_tween()
	tween_luz.set_parallel(true)
	tween_luz.set_trans(Tween.TRANS_SINE)
	tween_luz.set_ease(Tween.EASE_IN_OUT)

	# Exposición
	if world_env:
		tween_luz.tween_property(
			world_env, 
			"tonemap_exposure",
			exposure_objetivo,
			duracion
		)

	# Color general del juego
	if canvas_modulate:
		tween_luz.tween_property(
			canvas_modulate, 
			"color", 
			color_objetivo, 
			duracion
		)


# ============================
# ⭐ FUNCIONES DE ILUMINACIÓN
# ============================

func set_luz_superficial():
	_transicionar_luz(
		1.0,
		Color(1, 1, 1),
		0.6
	)

func set_luz_abisal():
	_transicionar_luz(
		0.25,
		Color(0.15, 0.20, 0.30),
		0.8
	)

func set_luz_hadal():
	_transicionar_luz(
		0.10,
		Color(0.10, 0.12, 0.17),
		1.0
	)



# ============================
# ⭐ MANEJO DE ZONAS (EVENTOS)
# ============================

func _on_zona_abisal_area_entered(area: Area2D) -> void:
	print("🔥 ENTRÓ A ABISAL:", area.name)
	if area.name == "Anzuelo":
		set_luz_abisal()

func _on_zona_hadal_area_entered(area: Area2D) -> void:
	print("🔥 ENTRÓ A HADAL:", area.name)
	if area.name == "Anzuelo":
		set_luz_hadal()

func _on_zona_superior_area_entered(area: Area2D) -> void:
	print("☀️ VOLVIÓ A SUPERFICIE:", area.name)
	if area.name == "Anzuelo":
		set_luz_superficial()
		
func recibir_user_id(id):
	print("📩 UserID recibido desde JS:", id)
	Global.guardar_progreso_en_server(id)
