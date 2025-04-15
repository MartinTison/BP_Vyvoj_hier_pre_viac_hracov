extends Node2D

# Táto funkcia zachytáva vstupy z klávesnice, myši alebo ovládača
func _input(event):
	# Skontroluje, či hráč stlačil klávesu "ui_cancel" (predvolene ESC)
	if event.is_action_pressed("ui_cancel"):
		# Pokúsi sa nájsť PauseMenu vo vnútri CanvasLayer
		var pause_menu = get_node_or_null("CanvasLayer/PauseMenu")
		if pause_menu:
			# Zobrazí menu a pozastaví hru
			pause_menu.visible = true
			get_tree().paused = true
