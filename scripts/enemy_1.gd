extends CharacterBody2D

@export var velocidade = 120

var vida = 1

@onready var player = $"../player"
@onready var body = $AnimatedSprite2D

var direcao_desvio = Vector2.ZERO
var tempo_desvio = 0.0
var alvo_aleatorio = Vector2.ZERO
var tempo_alvo_aleatorio = 0.0

var direcao_atual = "down"


func _physics_process(delta):

	if !player:
		return

	# Se estiver desviando de uma parede
	if tempo_desvio > 0:
		tempo_desvio -= delta
		velocity = direcao_desvio * velocidade

		if velocity.x > 0:
			if body.animation != "right":
				body.play("right")
		elif velocity.x < 0:
			if body.animation != "left":
				body.play("left")
		elif velocity.y > 0:
			if body.animation != "down":
				body.play("down")
		else:
			if body.animation != "up":
				body.play("up")

	else:
		# Atualiza o alvo aleatório de tempos em tempos
		if tempo_alvo_aleatorio <= 0:
			tempo_alvo_aleatorio = randf_range(0.5, 1.5)

			alvo_aleatorio = player.global_position + Vector2(
				randf_range(-64, 64),
				randf_range(-64, 64)
			)
		else:
			tempo_alvo_aleatorio -= delta

		var diferenca = alvo_aleatorio - global_position
		var margem = 16

		# Só troca para horizontal se a diferença for significativa
		if abs(diferenca.x) > abs(diferenca.y) + margem:
			if diferenca.x > 0:
				direcao_atual = "right"
			else:
				direcao_atual = "left"

		# Só troca para vertical se a diferença for significativa
		elif abs(diferenca.y) > abs(diferenca.x) + margem:
			if diferenca.y > 0:
				direcao_atual = "down"
			else:
				direcao_atual = "up"

		match direcao_atual:
			"right":
				velocity = Vector2.RIGHT * velocidade
				if body.animation != "right":
					body.play("right")

			"left":
				velocity = Vector2.LEFT * velocidade
				if body.animation != "left":
					body.play("left")

			"down":
				velocity = Vector2.DOWN * velocidade
				if body.animation != "down":
					body.play("down")

			"up":
				velocity = Vector2.UP * velocidade
				if body.animation != "up":
					body.play("up")

	move_and_slide()

	# Desvio ao bater em paredes
	if get_slide_collision_count() > 0 and tempo_desvio <= 0:
		var colisao = get_slide_collision(0)
		var normal = colisao.get_normal()

		# Parede vertical
		if abs(normal.x) > 0.9:
			direcao_desvio = Vector2(
				0,
				sign(player.global_position.y - global_position.y)
			)
		# Parede horizontal
		else:
			direcao_desvio = Vector2(
				sign(player.global_position.x - global_position.x),
				0
			)

		tempo_desvio = 0.3


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("tomar_dano"):
		body.tomar_dano()


func tomar_dano():
	vida -= 1

	if vida <= 0:
		queue_free()
