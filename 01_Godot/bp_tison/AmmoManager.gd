extends CanvasLayer

var player1_ammo = []
var player2_ammo = []

var max_ammo = 6
var reload_time = 1.5 # sekundy

var reload_timer1: Timer
var reload_timer2: Timer

func _ready():
	# Získaj všetky ammo ikonky pre hráča 1
	var ammo_container1 = get_node_or_null("Player1Ammo")
	if ammo_container1:
		for box in ammo_container1.get_children():
			for bullet in box.get_children():
				player1_ammo.append(bullet)

	# Získaj všetky ammo ikonky pre hráča 2
	var ammo_container2 = get_node_or_null("Player2Ammo")
	if ammo_container2:
		for box in ammo_container2.get_children():
			for bullet in box.get_children():
				player2_ammo.append(bullet)

	# Timer pre Player1
	reload_timer1 = Timer.new()
	reload_timer1.wait_time = reload_time
	reload_timer1.one_shot = false
	reload_timer1.timeout.connect(_on_reload_timer1)
	add_child(reload_timer1)

	# Timer pre Player2
	reload_timer2 = Timer.new()
	reload_timer2.wait_time = reload_time
	reload_timer2.one_shot = false
	reload_timer2.timeout.connect(_on_reload_timer2)
	add_child(reload_timer2)

func use_ammo(player: int) -> bool:
	var ammo_list = player1_ammo if player == 1 else player2_ammo

	if ammo_list.size() > 0:
		var bullet = ammo_list.pop_back()
		bullet.queue_free()

		# Spusti alebo reštartuj dobíjanie
		if player == 1:
			reload_timer1.start()
		elif player == 2:
			reload_timer2.start()

		return true
	else:
		print("Player %d: Out of ammo" % player)
		return false

func _on_reload_timer1():
	reload_ammo(1)
	if player1_ammo.size() >= max_ammo:
		reload_timer1.stop()

func _on_reload_timer2():
	reload_ammo(2)
	if player2_ammo.size() >= max_ammo:
		reload_timer2.stop()

func reload_ammo(player: int):
	var ammo_list = player1_ammo if player == 1 else player2_ammo
	if ammo_list.size() >= max_ammo:
		return

	var new_bullet = TextureRect.new()
	new_bullet.texture = preload("res://assets/Cannon_Ball2.png")
	new_bullet.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	new_bullet.custom_minimum_size = Vector2(16, 16)

	var container_name = "Player1Ammo" if player == 1 else "Player2Ammo"
	var ammo_container = get_node(container_name)

	for box in ammo_container.get_children():
		if box.get_child_count() < 3:
			box.add_child(new_bullet)
			ammo_list.append(new_bullet)
			break
