extends Node2D

func _on_porta_body_entered(body: Node2D) -> void:
	if body.name == "vilao":
		body.queue_free()
