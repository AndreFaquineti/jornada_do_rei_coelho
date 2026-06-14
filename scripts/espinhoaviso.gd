extends Node2D

@export var espinho_scene: PackedScene

func _ready():

	await get_tree().create_timer(1.0).timeout

	var espinho = espinho_scene.instantiate()
	espinho.global_position = global_position

	get_tree().current_scene.add_child(espinho)

	queue_free()
