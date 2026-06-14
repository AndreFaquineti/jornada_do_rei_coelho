extends Area2D

func _ready():

	scale = Vector2.ZERO

	$CollisionShape2D.disabled = true

	var tween = create_tween()

	tween.tween_property(
		self,
		"scale",
		Vector2(2, 2),
		0.25
	)

	tween.tween_property(
		self,
		"scale",
		Vector2.ONE,
		0.1
	)

	await tween.finished

	$CollisionShape2D.disabled = false

	await get_tree().create_timer(1.5).timeout

	queue_free()


func _on_body_entered(body):

	if body.has_method("tomar_dano"):
		body.tomar_dano()
