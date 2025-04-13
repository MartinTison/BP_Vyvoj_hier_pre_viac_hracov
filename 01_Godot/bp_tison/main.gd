extends Node2D

func _input(event):
	if event.is_action_pressed("ui_cancel"):  # predvolené je Esc
		var pause_menu = get_node_or_null("CanvasLayer/PauseMenu")
		if pause_menu:
			pause_menu.visible = true
			get_tree().paused = true
