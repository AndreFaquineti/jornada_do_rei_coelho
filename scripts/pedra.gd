extends Area2D

var direcao = Vector2.ZERO
var velocidade = 450

func _ready():
	body_entered.connect(contato)

func _process(delta):
	position += direcao * velocidade * delta

func contato(body):
	if body.has_method("toma_dano"):
		body.toma_dano()
		queue_free()  # Destroi a pedra
