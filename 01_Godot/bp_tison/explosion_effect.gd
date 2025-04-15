extends Node2D

# Táto funkcia sa zavolá hneď po načítaní (spawnutí) objektu do scény
func _ready():
	# Počká 0.3 sekundy a až potom pokračuje
	await get_tree().create_timer(0.3).timeout
	# Vymaže (zničí) tento objekt zo scény
	queue_free()
