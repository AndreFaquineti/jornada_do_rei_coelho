extends CharacterBody2D

@export var speed = 200
@export var pedra_scene : PackedScene

var vida = 3
var pode_atirar = true

@onready var body = $bodySprite2D
@onready var feet = $feetSprite2D
@onready var hud = $"../CanvasLayer/HUD"

func _ready():
	await get_tree().process_frame
	hud.atualizar_vida(vida)

func _physics_process(delta):

	var direction = Vector2.ZERO

	if Input.is_action_pressed("right"):
		direction.x += 1

	if Input.is_action_pressed("left"):
		direction.x -= 1

	if Input.is_action_pressed("down"):
		direction.y += 1

	if Input.is_action_pressed("up"):
		direction.y -= 1

	direction = direction.normalized()

	velocity = direction * speed

	move_and_slide()

	controlar_tiro()

	# PARADO
	if direction == Vector2.ZERO:

		feet.play("default")

		return

	# ANDANDO
	feet.play("andando")

	# DIREÇÕES
	if direction.x > 0:
		body.play("right")

	elif direction.x < 0:
		body.play("left")

	elif direction.y > 0:
		body.play("down")

	elif direction.y < 0:
		body.play("up")


func controlar_tiro():

	if not pode_atirar:
		return

	var direcao_tiro = Vector2.ZERO

	if Input.is_key_pressed(KEY_RIGHT):
		direcao_tiro.x += 1

	if Input.is_key_pressed(KEY_LEFT):
		direcao_tiro.x -= 1

	if Input.is_key_pressed(KEY_UP):
		direcao_tiro.y -= 1

	if Input.is_key_pressed(KEY_DOWN):
		direcao_tiro.y += 1

	if direcao_tiro != Vector2.ZERO:
		direcao_tiro = direcao_tiro.normalized()
		atirar(direcao_tiro)


func atirar(direcao):

	pode_atirar = false

	var pedra = pedra_scene.instantiate()

	pedra.position = position
	pedra.direcao = direcao

	get_parent().add_child(pedra)

	await get_tree().create_timer(0.2).timeout

	pode_atirar = true


func tomar_dano():

	vida -= 1

	if vida < 0:
		vida = 0

	hud.atualizar_vida(vida)

	if vida == 0:
		morrer()

func morrer():
	get_tree().change_scene_to_file("res://scenes/gameover.tscn")
