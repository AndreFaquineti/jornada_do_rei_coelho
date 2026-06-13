extends AudioStreamPlayer2D

func _ready():
	if !playing:
		play()
