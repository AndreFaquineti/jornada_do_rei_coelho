extends CharacterBody2D

@export var velocidade = 100
var vida = 1;

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


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("tomar_dano"):
		body.tomar_dano()
		
		
func tomar_dano():
	vida -= 1

	if vida <= 0: 
		queue_free()
