extends Control

# Táto funkcia sa spustí, keď používateľ klikne na tlačidlo "Back"
func _on_back_button_pressed():
	# Prepne scénu späť na hlavné menu
	get_tree().change_scene_to_file("res://main_menu.tscn")
