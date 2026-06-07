extends Node2D

@export var inimigos: Array[PackedScene]

@onready var timer = $Timer


func _ready():
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
	timer.wait_time = randf_range(1.0, 4.0)
