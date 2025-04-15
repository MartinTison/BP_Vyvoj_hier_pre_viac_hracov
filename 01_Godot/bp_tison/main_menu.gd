extends Control

# Spustenie hlavnej hernej scény po kliknutí na "Start"
func _on_play_button_pressed():
	var main_scene = load("res://main.tscn")
	get_tree().change_scene_to_packed(main_scene)

# Ukončenie hry po kliknutí na "Exit"
func _on_exit_button_pressed():
	get_tree().quit()

# Prechod do obrazovky s nápovedou po kliknutí na "Help"
func _on_help_button_pressed():
	get_tree().change_scene_to_file("res://help_menu.tscn")
