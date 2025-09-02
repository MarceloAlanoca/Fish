extends Area2D
var pez_enganchado: CharacterBody2D = null

func _ready():
	$".".body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body is CharacterBody2D and body.has_method("set_enganchado") and pez_enganchado == null:
		pez_enganchado = body
		pez_enganchado.set_enganchado(true, self)

func soltar_pez():
	if pez_enganchado:
		pez_enganchado.set_enganchado(false, null)
		pez_enganchado = null
