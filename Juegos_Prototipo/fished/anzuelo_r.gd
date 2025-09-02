extends Node2D

var pez_enganchado: CharacterBody2D = null

func _ready() -> void:
	var area = $Anzuelo_P
	if area:
		area.body_entered.connect(_on_body_entered)
		print("✅ Anzuelo listo, esperando peces...")
	else:
		push_error("❌ No encontré el Area2D en el anzuelo")

func _on_body_entered(body: Node) -> void:
	if pez_enganchado == null and body is CharacterBody2D and body.has_method("set_enganchado"):
		pez_enganchado = body
		pez_enganchado.set_enganchado(true, self)
		print("🎣 ¡Pez enganchado!")


   
