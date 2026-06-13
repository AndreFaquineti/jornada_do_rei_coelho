extends Sprite2D

var piscando = false
var tempo = 0.0

func _process(delta):
	if piscando:
		tempo += delta
		visible = sin(tempo * 8) > 0
