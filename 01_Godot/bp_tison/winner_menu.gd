extends Control

# Referencie na prvky víťaznej obrazovky
@onready var winner_label = $WinnerLabel
@onready var restart_button = $HBoxContainer/RestartButton
@onready var exit_button = $HBoxContainer/ExitButton

# Po načítaní scény pripojí signály ku kliknutiam na tlačidlá
func _ready():
	restart_button.pressed.connect(_on_restart_pressed)
	exit_button.pressed.connect(_on_exit_pressed)

# Zobrazí meno víťaza, pozastaví hru a zobrazí menu
func show_winner(player_name: String):
	winner_label.text = player_name + " wins!"
	visible = true
	get_tree().paused = true

# Reštartuje aktuálnu scénu (začne nový zápas)
func _on_restart_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

# Ukončí zápas a vráti sa do hlavného menu
func _on_exit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main_menu.tscn")
