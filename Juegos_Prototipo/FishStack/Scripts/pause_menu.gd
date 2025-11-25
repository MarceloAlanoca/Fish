extends Control

@onready var boton_continuar = $BotonContinuar
@onready var boton_opciones = $BotonOpciones
@onready var boton_menu = $BotonMenuPrincipal

func _ready():
	visible = false  # No se ve al inicio por seguridad

	boton_continuar.pressed.connect(_continuar)
	boton_opciones.pressed.connect(_abrir_opciones)
	boton_menu.pressed.connect(_volver_menu_principal)

	# Para que la UI funcione aunque el juego esté pausado
	process_mode = Node.PROCESS_MODE_ALWAYS


# ================================
# ▶️ CONTINUAR
# ================================
func _continuar():
	get_tree().paused = false
	visible = false


# ================================
# ⚙️ OPCIONES
# ================================
func _abrir_opciones():
	var opciones = load("res://Scene/MenuOpciones.tscn").instantiate()
	opciones.origen = "juego"
	
	# Agregar menú de opciones
	get_parent().add_child(opciones)

	# Ocultar pausa completamente
	self.visible = false
	self.process_mode = Node.PROCESS_MODE_DISABLED



# ================================
# 🏠 VOLVER AL MENÚ PRINCIPAL
# ================================
func _volver_menu_principal():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scene/inicio_control.tscn")
