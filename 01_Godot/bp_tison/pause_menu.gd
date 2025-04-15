extends Control

# Táto funkcia sa spustí pri načítaní scény
func _ready():
	# Menu je na začiatku skryté – zobrazí sa len po stlačení ESC
	visible = false

# Pokračovanie v hre po kliknutí na tlačidlo "Resume"
func _on_resume_button_pressed():
	get_tree().paused = false  # Odpauzuje hru
	visible = false            # Skryje pause menu

# Ukončenie zápasu – návrat do hlavného menu
func _on_exit_button_pressed():
	get_tree().paused = false  # Odpauzuje hru pred zmenou scény
	get_tree().change_scene_to_file("res://main_menu.tscn")
