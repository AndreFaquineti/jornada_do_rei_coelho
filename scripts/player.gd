extends CharacterBody2D

@export var speed = 200

var velocidade = speed
var pode_levar_dano = true

	
@export var pedra_scene : PackedScene

var vida = 3
var pode_atirar = true
var tem_coroa = false
@onready var body = $bodySprite2D
@onready var feet = $feetSprite2D
@onready var hud = $"../CanvasLayer/HUD"
@onready var coroa =$coroa


func _ready():
	await get_tree().process_frame
	hud.atualizar_vida(vida)
	coroa.visible = false



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

	velocity = direction * velocidade

	move_and_slide()

	controlar_tiro()

	# PARADO
	if direction == Vector2.ZERO:

		feet.play("default")
		if tem_coroa == false:
			body.play("default")
		else:
			body.play("down2")

		return

	# ANDANDO
	feet.play("andando")

	# DIREÇÕES
	if direction.x > 0:
		if tem_coroa == false:
			body.play("right")
		else:
			body.play("right2")
			
	elif direction.x < 0:
		if tem_coroa == false:
			body.play("left")
		else:
			body.play("left2")

	elif direction.y > 0:
		if tem_coroa == false:
			body.play("down")
		else:
			body.play("down2")
			
	elif direction.y < 0:
		if tem_coroa == false:
			body.play("up")
		else:
			body.play("up2")

func pegar_coroa():
	tem_coroa = true
	$"../Label".visible = true

	await get_tree().create_timer(5.0).timeout

	get_tree().change_scene_to_file(
		"res://scenes/menu.tscn"
	)
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

	if not pode_levar_dano:
		return

	pode_levar_dano = false

	vida -= 1
	if vida < 0:
		vida = 0

	body.modulate = Color(1, 0, 0)
	hud.atualizar_vida(vida)

	await get_tree().create_timer(0.5).timeout

	body.modulate = Color(1, 1, 1)
	pode_levar_dano = true

	if vida == 0:
		morrer()

func morrer():
	get_tree().call_deferred(
		"change_scene_to_file",
		"res://scenes/gameover.tscn"
	)

func aplicar_lentidao():
	velocidade = speed * 0.5

func remover_lentidao():
	velocidade = speed
