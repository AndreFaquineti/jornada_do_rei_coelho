extends CharacterBody2D

@export var velocidade = 60

#@export var fireball_scene: PackedScene
@export var inimigos: Array[PackedScene]


var vida = 30
var vida_maxima = 30

@onready var player = $"../player"
@onready var body = $AnimatedSprite2D
@onready var skill_timer = $SkillTimer
@onready var hud = $"../CanvasLayer/HUD"

var direcao_desvio = Vector2.ZERO
var tempo_desvio = 0.0
var alvo_aleatorio = Vector2.ZERO
var tempo_alvo_aleatorio = 0.0

var direcao_atual = "down"
var usando_habilidade = false


func _ready():
	inimigos = [
		preload("res://scenes/enemy_1.tscn"),
		preload("res://scenes/enemy_2.tscn"),
		preload("res://scenes/enemy_3.tscn")
	]
	hud.atualizar_vida_boss(vida, vida_maxima)

	skill_timer.start()


func _physics_process(delta):

	if !player:
		return

	if usando_habilidade:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	if tempo_desvio > 0:

		tempo_desvio -= delta
		velocity = direcao_desvio * velocidade

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

			if diferenca.x > 0:
				direcao_atual = "right"
			else:
				direcao_atual = "left"

		elif abs(diferenca.y) > abs(diferenca.x) + margem:

			if diferenca.y > 0:
				direcao_atual = "down"
			else:
				direcao_atual = "up"

		match direcao_atual:

			"right":
				velocity = Vector2.RIGHT * velocidade
				body.play("right")

			"left":
				velocity = Vector2.LEFT * velocidade
				body.play("left")

			"down":
				velocity = Vector2.DOWN * velocidade
				body.play("down")

			"up":
				velocity = Vector2.UP * velocidade
				body.play("up")

	move_and_slide()

	if get_slide_collision_count() > 0 and tempo_desvio <= 0:

		var colisao = get_slide_collision(0)
		var normal = colisao.get_normal()

		if abs(normal.x) > 0.9:

			direcao_desvio = Vector2(
				0,
				sign(player.global_position.y - global_position.y)
			)

		else:

			direcao_desvio = Vector2(
				sign(player.global_position.x - global_position.x),
				0
			)

		tempo_desvio = 0.3


func _on_skill_timer_timeout():

	if usando_habilidade:
		return

	usando_habilidade = true

	var habilidade = randi_range(0, 1)

	if habilidade == 0:

#		atacar_circulo()
		print("f")

	else:

		await invocar_inimigos()

	usando_habilidade = false


#func atacar_circulo():

#	var quantidade = 12

#	for i in range(quantidade):

#		var angulo = (TAU / quantidade) * i

#		var direcao = Vector2(
#			cos(angulo),
#			sin(angulo)
#		)

#		var fogo = fireball_scene.instantiate()

#		fogo.global_position = global_position
#		fogo.direcao = direcao

#		get_tree().current_scene.add_child(fogo)


func invocar_inimigos():

	var pos_original = global_position

	for i in range(10):

		global_position = pos_original + Vector2(
			randf_range(-4, 4),
			randf_range(-4, 4)
		)

		await get_tree().create_timer(0.05).timeout

	global_position = pos_original

	for i in range(3):

		if inimigos.is_empty():
			return

		var inimigo_escolhido = inimigos.pick_random()
		var instancia = inimigo_escolhido.instantiate()

		instancia.global_position = global_position + Vector2(
			randf_range(-80, 80),
			randf_range(-80, 80)
		)

		get_tree().current_scene.add_child(instancia)


func _on_area_2d_body_entered(body):

	if body.has_method("tomar_dano"):
		body.tomar_dano()


func tomar_dano():

	vida -= 1

	hud.atualizar_vida_boss(vida, vida_maxima)

	if vida <= 0:
		queue_free()
