extends Area2D

var direcao = Vector2.ZERO
var velocidade = 450

func _process(delta):

	position += direcao * velocidade * delta
