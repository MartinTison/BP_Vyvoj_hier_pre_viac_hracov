extends Control


func _on_play_button_pressed():
	var main_scene = load("res://main.tscn")
	get_tree().change_scene_to_packed(main_scene)


func _on_exit_button_pressed():
	get_tree().quit()


func _on_help_button_pressed() -> void:
	pass # Replace with function body.
