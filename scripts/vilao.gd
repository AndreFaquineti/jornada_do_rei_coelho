extends CharacterBody2D

var destino: Vector2
var velocidade = 180

@onready var anim = $AnimatedSprite2D

func _physics_process(delta):

	var diferenca = destino - global_position

	if diferenca.length() < 16:
		queue_free()
		return

	if abs(diferenca.x) > 16:

		if diferenca.x > 0:
			velocity = Vector2.RIGHT * velocidade
			anim.play("right")
		else:
			velocity = Vector2.LEFT * velocidade
			anim.play("left")

	elif abs(diferenca.y) > 16:

		if diferenca.y > 0:
			velocity = Vector2.DOWN * velocidade
			anim.play("down")
		else:
			velocity = Vector2.UP * velocidade
			anim.play("up")

	else:
		velocity = Vector2.ZERO

	move_and_slide()
