extends Control

@onready var slider_volumen: HSlider = $HSlider
@onready var label_porcentaje: Label = $LabelPorcentaje
@onready var boton_continuar: Button = $BotonContinuar
@onready var boton_retroceder: Button = $BotonRetroceder

@export var origen := "juego"   # "juego" o "inicio"

func _ready():
	# Mostrar/ocultar continuar según origen
	boton_continuar.pressed.connect(_on_continuar)
	boton_continuar.visible = (origen == "juego")

	# Conectar retroceder
	boton_retroceder.pressed.connect(_on_retroceder)

	# Obtener volumen del master
	var master_bus := AudioServer.get_bus_index("Master")
	var vol_db := AudioServer.get_bus_volume_db(master_bus)

	var vol_lineal := db_to_linear(vol_db)
	slider_volumen.value = vol_lineal

	label_porcentaje.text = str(round(vol_lineal * 100)) + "%"

	slider_volumen.value_changed.connect(_on_volumen_cambiado)


func _on_volumen_cambiado(value: float):
	var vol_db := linear_to_db(value)
	var master_bus := AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(master_bus, vol_db)

	label_porcentaje.text = str(round(value * 100)) + "%"


func _on_retroceder():
	if origen == "juego":
		# Buscar PauseMenu en el mismo padre (CanvasLayer)
		var pausa = get_parent().get_node_or_null("PauseMenu")
		
		if pausa:
			pausa.visible = true
			pausa.process_mode = Node.PROCESS_MODE_ALWAYS
		
		queue_free()

	elif origen == "inicio":
		queue_free()
		
func _on_continuar():
	if origen == "juego":
		# Reanudar el juego
		get_tree().paused = false
		
		# Cerrar menú de opciones
		queue_free()
		
	elif origen == "inicio":
		# Si venís del menú principal NO debe continuar
		print("Continuar no está disponible en origen = inicio")
