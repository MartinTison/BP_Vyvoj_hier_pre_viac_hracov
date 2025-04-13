extends Control

@onready var winner_label = $WinnerLabel
@onready var restart_button = $HBoxContainer/RestartButton
@onready var exit_button = $HBoxContainer/ExitButton

func _ready():
	restart_button.pressed.connect(_on_restart_pressed)
	exit_button.pressed.connect(_on_exit_pressed)

func show_winner(player_name: String):
	winner_label.text = player_name + " wins!"
	visible = true
	get_tree().paused = true

func _on_restart_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_exit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main_menu.tscn")
