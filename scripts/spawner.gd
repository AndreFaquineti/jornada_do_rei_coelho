extends Node2D

@export var enemy1_scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawnar_inimigos()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func spawnar_inimigos():
	while true:
		var enemy1 = enemy1_scene.instantiate()
		enemy1.position = position
		get_parent().add_child(enemy1)
		await get_tree().create_timer(1.0).timeout
