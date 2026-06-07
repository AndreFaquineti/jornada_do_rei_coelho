extends Area2D

var direcao = Vector2.ZERO
var velocidade = 450

func _process(delta):

	position += direcao * velocidade * delta


func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		return

	if body.has_method("tomar_dano"):
		body.tomar_dano()
		
	queue_free()
