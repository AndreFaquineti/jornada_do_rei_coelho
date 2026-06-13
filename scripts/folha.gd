extends Area2D


func _on_body_entered(body):
	if body.has_method("aplicar_lentidao"):
		body.aplicar_lentidao()

func _on_body_exited(body):
	if body.has_method("remover_lentidao"):
		body.remover_lentidao()
