extends CharacterBody2D

# Scéna projektilu exportovaná do inšpektora
@export var projectile_scene: PackedScene

# Parametre pohybu a ovládania
var speed = 90
var reverse_speed = 50
var acceleration = 100
var deceleration = 200
var rotation_speed = 1.5
var current_speed = 0.0

func _physics_process(delta):
	var input_direction = 0.0

	# Vpred / vzad pre hráča 2
	if Input.is_action_pressed("move_forward_p2"):
		input_direction = 1
	elif Input.is_action_pressed("move_backward_p2"):
		input_direction = -0.5

	# Zrýchlenie alebo spomalenie podľa vstupu
	if input_direction != 0:
		current_speed = move_toward(current_speed, input_direction * speed, acceleration * delta)
	else:
		current_speed = move_toward(current_speed, 0, deceleration * delta)

	# Rotácia doľava / doprava pre hráča 2
	if Input.is_action_pressed("turn_left_p2"):
		rotation -= rotation_speed * delta
	if Input.is_action_pressed("turn_right_p2"):
		rotation += rotation_speed * delta

	# Smer pohybu – nadol rotovaný podľa rotácie (hráč 2 je hore)
	velocity = Vector2.DOWN.rotated(rotation) * current_speed

	# Obmedzenie na hornú polovicu obrazovky
	var screen_size = get_viewport().size
	var margin = 10
	position.x = clamp(position.x, margin, screen_size.x - margin)
	position.y = clamp(position.y, margin, screen_size.y / 2 - margin)

	move_and_slide()

	# Výstrel pri stlačení klávesy
	if Input.is_action_just_pressed("shoot_p2"):
		shoot_from_bottom_facing_side()

# Výstrel hráča 2 zo strany, ktorá smeruje najbližšie nadol
func shoot_from_bottom_facing_side():
	var ammo_manager = get_node("/root/Main/AmmoUI")
	if ammo_manager == null:
		print("Ammo manager not found")
		return

	# Kontrola a odobratie náboja hráčovi 2
	if not ammo_manager.use_ammo(2):
		return

	if projectile_scene == null:
		return

	# Vypočítanie uhla pre výstrel na ľavú / pravú stranu
	var left_angle = rotation - PI / 2
	var right_angle = rotation + PI / 2

	# Porovnanie, ktorá strana je viac "dolu" podľa dot produktu
	var down_vector = Vector2.DOWN
	var left_dot = down_vector.dot(Vector2.UP.rotated(left_angle))
	var right_dot = down_vector.dot(Vector2.UP.rotated(right_angle))

	var shot_angle = left_angle if left_dot > right_dot else right_angle
	var shot_direction = Vector2.UP.rotated(shot_angle)

	# Efekt výstrelu - záblesk + dym
	var muzzle_flash = preload("res://muzzle_flash.tscn").instantiate()
	muzzle_flash.global_position = global_position + shot_direction.normalized() * 32
	muzzle_flash.rotation = shot_angle
	get_tree().get_current_scene().add_child(muzzle_flash)

	muzzle_flash.get_node("ExplosionEffect").emitting = true
	muzzle_flash.get_node("SmokeEffect").emitting = true

	# Projektil s nastaveným smerom a pozíciou
	var projectile = projectile_scene.instantiate()
	projectile.direction = shot_direction
	projectile.rotation = shot_angle
	projectile.global_position = global_position + shot_direction.normalized() * 32

	get_tree().get_current_scene().add_child(projectile)
