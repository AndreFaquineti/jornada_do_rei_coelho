extends CharacterBody2D

@export var velocidade = 100
@export var saude = 1

@onready var player = $"../player"
@onready var body = $AnimatedSprite2D

func _physics_process(delta):

	if !player:
		return

	var diferenca = player.global_position - global_position

	# Escolhe apenas uma das 4 direções
	if abs(diferenca.x) > abs(diferenca.y):

		velocity = Vector2(sign(diferenca.x), 0) * velocidade

		if velocity.x > 0:
			body.play("right")
		else:
			body.play("left")

	else:

		velocity = Vector2(0, sign(diferenca.y)) * velocidade

		if velocity.y > 0:
			body.play("down")
		else:
			body.play("up")

	move_and_slide()

func toma_dano(amount = 1):
	saude -= amount
	if saude <= 0:
		inimigo_morre()

func inimigo_morre():
	# Stop the enemy from moving/AI thinking
	set_physics_process(false)
	velocity = Vector2.ZERO

	# Optional: if you have a "death" animation
	# body.play("death")
	# await body.animation_finished

	queue_free()  # Remove the enemy from the scene
