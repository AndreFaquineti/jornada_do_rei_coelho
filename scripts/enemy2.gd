extends CharacterBody2D

@export var velocidade = 60
var distancia_ataque = 18.0
var vida = 3
var vida_maxima = 3
var pode_dar_dano = true
@onready var barra_vida = $ProgressBar
@onready var player = $"../player"
@onready var body = $AnimatedSprite2D

var direcao_desvio = Vector2.ZERO
var tempo_desvio = 0.0
var alvo_aleatorio = Vector2.ZERO
var tempo_alvo_aleatorio = 0.0

var direcao_atual = "down"

func _ready():
	add_to_group("inimigos")
	barra_vida.max_value = vida_maxima
	barra_vida.value = vida

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

		var dist_player = player.global_position.distance_to(global_position)

		if dist_player <= distancia_ataque:
			velocity = Vector2.ZERO
		else:
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

			if abs(diferenca.x) > abs(diferenca.y) + margem:
				direcao_atual = "right" if diferenca.x > 0 else "left"

			elif abs(diferenca.y) > abs(diferenca.x) + margem:
				direcao_atual = "down" if diferenca.y > 0 else "up"

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
	if !pode_dar_dano:
		return

	if body.has_method("tomar_dano"):

		pode_dar_dano = false

		body.tomar_dano()

		# Recuo do inimigo
		var direcao_recuo = (
			global_position - body.global_position
		).normalized()

		global_position += direcao_recuo * 40

		await get_tree().create_timer(1.0).timeout

		pode_dar_dano = true


func tomar_dano():
	vida -= 1

	barra_vida.value = vida

	if vida <= 0:
		queue_free()
