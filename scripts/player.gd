extends CharacterBody2D

@export var speed = 200

@onready var body = $bodySprite2D
@onready var feet = $feetSprite2D
@export var pedra_scene : PackedScene

var pode_atirar = true

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

	if Input.is_key_pressed(KEY_RIGHT):

		if pode_atirar:
			atirar(Vector2.RIGHT)

	elif Input.is_key_pressed(KEY_LEFT):

		if pode_atirar:
			atirar(Vector2.LEFT)

	elif Input.is_key_pressed(KEY_UP):

		if pode_atirar:
			atirar(Vector2.UP)

	elif Input.is_key_pressed(KEY_DOWN):

		if pode_atirar:
			atirar(Vector2.DOWN)


func atirar(direcao):

	pode_atirar = false

	var pedra = pedra_scene.instantiate()

	pedra.position = position
	pedra.direcao = direcao

	get_parent().add_child(pedra)

	await get_tree().create_timer(0.2).timeout

	pode_atirar = true
