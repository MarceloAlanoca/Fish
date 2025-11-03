
extends Control
class_name InterfazUsuario

@onready var label_dinero := $Label

var dinero_actual: int = 0

func _ready():
	actualizar_label()

# Llamar cada vez que se venda un pez
func actualizar_dinero(nuevo_valor: int):
	dinero_actual = nuevo_valor
	actualizar_label()

func actualizar_label():
	label_dinero.text =  str(dinero_actual)
