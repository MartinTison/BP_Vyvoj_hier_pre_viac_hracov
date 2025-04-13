extends Area2D

func _on_area_entered(area: Area2D):
	print("Ostrov bol zasiahnutý!")
	area.queue_free()
