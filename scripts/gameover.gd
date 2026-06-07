extends Control


func _on_btn_voltar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")


func _on_btn_jogardnv_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world.tscn")
