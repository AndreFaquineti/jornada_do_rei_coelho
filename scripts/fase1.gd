extends Node2D

@export var tempo_maximo = 60.0

var tempo_restante
var fase_concluida = false

@onready var hud = $CanvasLayer/HUD
var cena

func _ready():
	tempo_restante = tempo_maximo

	var nome_fase = get_tree().current_scene.name
	if nome_fase == "world":
		cena = "res://scenes/corredor1.tscn"

	elif nome_fase == "fase2":
		cena = "res://scenes/corredor_2.tscn"
		
	elif nome_fase == "fase3":
		cena = "res://scenes/corredor3.tscn"
	
	elif nome_fase == "fase4":
		cena = "res://scenes/corredor4.tscn"


func _process(delta):

	if !fase_concluida:
		tempo_restante -= delta

		if tempo_restante <= 0:
			tempo_restante = 0
			fim_da_fase()

	hud.atualizar_tempo(tempo_restante, tempo_maximo)


func fim_da_fase():

	fase_concluida = true

	$spawner1/Timer.stop()
	$spawner2/Timer.stop()
	$spawner3/Timer.stop()
	var nome_fase = get_tree().current_scene.name
	if nome_fase == "fase4":
		$spawner4/Timer.stop()

	for inimigo in get_tree().get_nodes_in_group("inimigos"):
		inimigo.queue_free()

	$seta.visible = true
	$seta.piscando = true
	$saida.monitoring = true


func _on_saida_body_entered(body: Node2D) -> void:
	if !fase_concluida:
		return

	if body.name == "player":
		get_tree().call_deferred(
		"change_scene_to_file",
		cena
	)
