extends Control

func _ready():
	visible = false  # Na začiatku sa nezobrazuje


func _on_resume_button_pressed():
	get_tree().paused = false
	visible = false


func _on_exit_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main_menu.tscn")
