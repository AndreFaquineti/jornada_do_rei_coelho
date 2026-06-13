extends Node2D

var cena

func _ready():

	var nome_fase = get_tree().current_scene.name
	if nome_fase == "Corredor1":
		cena = "res://scenes/fase2.tscn"

	elif nome_fase == "Corredor2":
		cena = "res://scenes/fase_3.tscn"
	
	elif nome_fase == "Corredor3":
		cena = "res://scenes/fase4.tscn"
		
	elif nome_fase == "Corredor4":
		cena = "res://scenes/faseboss.tscn"

func _on_saida_body_entered(body: Node2D) -> void:
	if body.name == "player":
		get_tree().call_deferred(
		"change_scene_to_file",
		cena
	)
