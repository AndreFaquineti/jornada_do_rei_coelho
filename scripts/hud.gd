extends Control

@onready var heart1 = $HBoxContainer/Heart1
@onready var heart2 = $HBoxContainer/Heart2
@onready var heart3 = $HBoxContainer/Heart3

@export var heart_full : Texture2D
@export var heart_empty : Texture2D

func atualizar_vida(vida):

	heart1.texture = heart_full if vida >= 1 else heart_empty
	heart2.texture = heart_full if vida >= 2 else heart_empty
	heart3.texture = heart_full if vida >= 3 else heart_empty
