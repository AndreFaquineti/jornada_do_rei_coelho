extends Control

func _on_btn_jogar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world.tscn")


func _on_btn_sair_pressed() -> void:
	get_tree().quit()


func _on_btn_creditos_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/creditos.tscn")
