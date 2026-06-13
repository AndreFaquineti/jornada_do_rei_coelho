extends Node2D

@export var inimigos: Array[PackedScene]

@onready var timer = $Timer
var tempo

func _ready():
	var nome_fase = get_tree().current_scene.name
	if nome_fase == "world":
		tempo = randf_range(2.0, 6.0)
		inimigos = [
			preload("res://scenes/enemy_1.tscn"),
		]

	elif nome_fase == "fase2":
		tempo = randf_range(3.0, 5.0)
		inimigos = [
			preload("res://scenes/enemy_1.tscn"),
			preload("res://scenes/enemy_2.tscn"),
		]
	elif nome_fase == "fase3":
		tempo = randf_range(3.0, 3.0)
		inimigos = [
			preload("res://scenes/enemy_1.tscn"),
			preload("res://scenes/enemy_2.tscn"),
			preload("res://scenes/enemy_3.tscn")
		]
	elif nome_fase == "fase4":
		tempo = randf_range(5, 8)
		inimigos = [
			preload("res://scenes/enemy_1.tscn"),
			preload("res://scenes/enemy_2.tscn"),
			preload("res://scenes/enemy_3.tscn")
		]

	set_random_time()
	timer.start()

func _on_timer_timeout():
	spawn_inimigo()
	set_random_time()
	timer.start()


func spawn_inimigo():
	if inimigos.is_empty():
		return

	var inimigo_escolhido = inimigos.pick_random()
	var instancia = inimigo_escolhido.instantiate()

	# spawn na posição do spawner
	instancia.global_position = global_position

	get_tree().current_scene.add_child(instancia)


func set_random_time():
	timer.wait_time = tempo
