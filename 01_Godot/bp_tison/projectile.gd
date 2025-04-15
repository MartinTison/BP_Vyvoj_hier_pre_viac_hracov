extends Area2D

# Rýchlosť pohybu projektilu
var speed = 200

# Smer pohybu – musí byť nastavený pri vytvorení strely
var direction = Vector2.ZERO

# Prednačítaná scéna efektu výbuchu
var explosion_scene = preload("res://explosion_effect.tscn")

# Pohyb projektilu
func _physics_process(delta):
	position += direction * speed * delta

	# Ak strela opustí obrazovku (aj s okrajom), zničí sa
	if position.x < -100 or position.x > 1400 or position.y < -100 or position.y > 800:
		queue_free()

# Kolízia s iným objektom
func _on_area_entered(area):
	print("Zásah:", area.name)

	# Vypne detekciu ďalších kolízií, aby nebola reakcia viackrát
	set_deferred("monitoring", false)

	# Spustenie výbuchu
	spawn_explosion()

	# Zníženie života hráčovi podľa mena kolidovaného objektu
	if area.name == "Hitbox":
		get_node("/root/Main/UI").remove_life(1)
	elif area.name == "Hitbox2":
		get_node("/root/Main/UI").remove_life(2)

	# Vymazanie projektilu po zásahu
	queue_free()

# Vytvorenie efektu výbuchu na mieste strely
func spawn_explosion():
	var explosion = explosion_scene.instantiate()
	explosion.global_position = global_position
	get_node("/root/Main").add_child(explosion)
