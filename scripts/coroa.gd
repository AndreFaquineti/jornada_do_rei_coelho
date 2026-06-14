extends Area2D

func _on_body_entered(body):

	if body.name == "player":

		body.pegar_coroa()

		queue_free()
