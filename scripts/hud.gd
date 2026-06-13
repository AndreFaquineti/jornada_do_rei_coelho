extends Control

@onready var heart1 = $HBoxContainer/Heart1
@onready var heart2 = $HBoxContainer/Heart2
@onready var heart3 = $HBoxContainer/Heart3

@onready var barra_tempo = $BarraTempo
@onready var barra_boss = $BarraBoss
@onready var relogio = $TextureRect

@export var heart_full : Texture2D
@export var heart_empty : Texture2D


func _ready():

	barra_boss.hide()

	var nome_fase = get_tree().current_scene.name

	if nome_fase == "faseboss":
		barra_tempo.hide()
		relogio.hide()
		barra_boss.show()


func atualizar_tempo(atual, maximo):
	barra_tempo.max_value = maximo
	barra_tempo.value = atual


func atualizar_vida_boss(vida, vida_maxima):
	barra_boss.max_value = vida_maxima
	barra_boss.value = vida


func atualizar_vida(vida):

	heart1.texture = heart_full if vida >= 1 else heart_empty
	heart2.texture = heart_full if vida >= 2 else heart_empty
	heart3.texture = heart_full if vida >= 3 else heart_empty
