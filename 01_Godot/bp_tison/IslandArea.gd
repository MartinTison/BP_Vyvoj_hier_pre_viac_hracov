extends Area2D

# Funkcia sa spustí, keď do tejto oblasti vstúpi iný Area2D objekt
func _on_area_entered(area: Area2D):
	# Zničenie objektu, ktorý narazil do ostrova 
	area.queue_free()
