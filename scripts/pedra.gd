extends Area2D

var direcao = Vector2.ZERO
var velocidade = 500

func _process(delta):

	position += direcao * velocidade * delta
