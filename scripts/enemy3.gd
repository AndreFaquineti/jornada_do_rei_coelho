extends CharacterBody2D

@export var velocidade = 80
@export var folha_scene: PackedScene

var vida = 1
var pode_dar_dano = true
@onready var body = $AnimatedSprite2D
@onready var timer_folha = $Timerfolha

var direcao = Vector2.ZERO
var tempo_troca_direcao = 0.0


func _ready():
	randomize()
	escolher_nova_direcao()
	timer_folha.start()
	add_to_group("inimigos")

func _physics_process(delta):

	tempo_troca_direcao -= delta

	if tempo_troca_direcao <= 0:
		escolher_nova_direcao()

	velocity = direcao * velocidade

	# Animações
	if direcao == Vector2.RIGHT:
		body.play("right")
	elif direcao == Vector2.LEFT:
		body.play("left")
	elif direcao == Vector2.DOWN:
		body.play("down")
	elif direcao == Vector2.UP:
		body.play("up")

	move_and_slide()

	if get_slide_collision_count() > 0:
		desviar_parede()


func escolher_nova_direcao():

	tempo_troca_direcao = randf_range(1.0, 3.0)

	var direcoes = [
		Vector2.RIGHT,
		Vector2.LEFT,
		Vector2.UP,
		Vector2.DOWN
	]

	direcao = direcoes.pick_random()


func desviar_parede():

	# Volta um pouco para trás
	global_position -= direcao * 10

	# Se estava indo na horizontal, passa para vertical
	if direcao == Vector2.RIGHT or direcao == Vector2.LEFT:

		direcao = [
			Vector2.UP,
			Vector2.DOWN
		].pick_random()

	# Se estava indo na vertical, passa para horizontal
	else:

		direcao = [
			Vector2.LEFT,
			Vector2.RIGHT
		].pick_random()

	tempo_troca_direcao = randf_range(1.0, 3.0)


func _on_timer_folha_timeout():
	if folha_scene == null:
		return

	var folha = folha_scene.instantiate()
	folha.global_position = global_position

	get_tree().current_scene.add_child(folha)


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

	if vida <= 0:
		queue_free()
