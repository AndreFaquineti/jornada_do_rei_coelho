extends CharacterBody2D

@export var velocidade = 60

@export var inimigos: Array[PackedScene]
@export var aviso_scene: PackedScene
@export var vilao_scene: PackedScene
@export var coroa_scene: PackedScene

var distancia_ataque = 80.0
var pode_dar_dano = true
var vida = 100
var vida_maxima = 100
var tempo_recuo = 0.0
var direcao_recuo = Vector2.ZERO

@onready var player = $"../player"
@onready var body = $AnimatedSprite2D
@onready var hud = $"../CanvasLayer/HUD"
@onready var tilemap = $"../ColorRect/TileMap"

var direcao_desvio = Vector2.ZERO
var tempo_desvio = 0.0
var alvo_aleatorio = Vector2.ZERO
var tempo_alvo_aleatorio = 0.0

var direcao_atual = "down"
var usando_habilidade = false


func _ready():
	add_to_group("inimigos")
	inimigos = [
		preload("res://scenes/enemy_1.tscn"),
		preload("res://scenes/enemy_2.tscn"),
		preload("res://scenes/enemy_3.tscn")
	]
	hud.atualizar_vida_boss(vida, vida_maxima)


func _physics_process(delta):

	if !player:
		return
	if tempo_recuo > 0:
		tempo_recuo -= delta
		velocity = direcao_recuo * 200
		atualizar_animacao()
		move_and_slide()
		return
	if usando_habilidade:
		velocity = Vector2.ZERO
		atualizar_animacao()
		move_and_slide()
		return

	var distancia_player = global_position.distance_to(player.global_position)

	if distancia_player <= distancia_ataque:
		velocity = velocity.lerp(Vector2.ZERO, 0.3)
		atualizar_animacao()
		move_and_slide()
		return

	if tempo_desvio > 0:

		tempo_desvio -= delta
		velocity = direcao_desvio * velocidade
	
	else:

		if tempo_alvo_aleatorio <= 0:

			tempo_alvo_aleatorio = randf_range(0.5, 1.5)

			alvo_aleatorio = player.global_position + Vector2(
				randf_range(-16, 16),
				randf_range(-16, 16)
			)

		else:
			tempo_alvo_aleatorio -= delta

		var diferenca = alvo_aleatorio - global_position
		var margem = 8
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

			"left":
				velocity = Vector2.LEFT * velocidade

			"down":
				velocity = Vector2.DOWN * velocidade

			"up":
				velocity = Vector2.UP * velocidade
	atualizar_animacao()
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

func atualizar_animacao():

	if abs(velocity.x) > abs(velocity.y):

		if velocity.x > 0:
			body.play("right")
		elif velocity.x < 0:
			body.play("left")

	else:

		if velocity.y > 0:
			body.play("down")
		elif velocity.y < 0:
			body.play("up")

func _on_espinho_timer_timeout() -> void:
	if usando_habilidade:
		return

	atacar_espinho()

func _on_enemy_timer_timeout() -> void:
	if usando_habilidade:
		return

	invocar_inimigos()
	
func atacar_espinho():

	for i in range(18):

		var aviso = aviso_scene.instantiate()

		var pos_valida = false
		var pos

		while !pos_valida:

			var offset = Vector2(
				randf_range(-200, 200),
				randf_range(-200, 200)
			)

			pos = player.global_position + offset

			var celula = tilemap.local_to_map(
				tilemap.to_local(pos)
			)

			# Verifica se existe um tile nessa posição
			if tilemap.get_cell_source_id(0, celula) != -1:
				pos_valida = true

		pos.x = round(pos.x / 16.0) * 16
		pos.y = round(pos.y / 16.0) * 16

		aviso.global_position = pos

		get_tree().current_scene.add_child(aviso)

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

		var pos_valida = false
		var pos

		while !pos_valida:

			var direcao = Vector2(
				randf_range(-1, 1),
				randf_range(-1, 1)
			)

			if direcao == Vector2.ZERO:
				continue

			direcao = direcao.normalized()

			pos = global_position + direcao * randf_range(120, 200)

			var celula = tilemap.local_to_map(
				tilemap.to_local(pos)
			)

			if tilemap.get_cell_source_id(0, celula) != -1:
				pos_valida = true

		instancia.global_position = pos

		get_tree().current_scene.add_child(instancia)


func _on_area_2d_body_entered(body):

	if !pode_dar_dano:
		return

	if body.has_method("tomar_dano"):

		pode_dar_dano = false

		body.tomar_dano()

		direcao_recuo = (
			global_position - body.global_position
		).normalized()

		tempo_recuo = 0.2

		await get_tree().create_timer(1.0).timeout

		pode_dar_dano = true

func tomar_dano():

	vida -= 1

	hud.atualizar_vida_boss(vida, vida_maxima)

	if vida <= 0:
		call_deferred("morrer")
		

func morrer():

	var sprite = Sprite2D.new()
	sprite.texture = preload("res://sprites/carcacaboss.png")
	sprite.scale = Vector2(4, 4)
	sprite.z_index = 1
	sprite.global_position = global_position

	var vilao = vilao_scene.instantiate()
	var porta = get_parent().get_node("porta")

	vilao.global_position = global_position
	vilao.destino = porta.global_position

	var coroa = coroa_scene.instantiate()

	var centro_fase = Vector2(577, 306)

	var direcao_centro = (
		centro_fase - global_position
	).normalized()

	coroa.global_position = (
		global_position +
		direcao_centro * randf_range(100, 180)
	)

	get_parent().add_child(vilao)
	get_parent().add_child(coroa)
	get_parent().add_child(sprite)

	queue_free()
		
		
