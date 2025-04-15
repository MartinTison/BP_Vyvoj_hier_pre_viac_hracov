extends CharacterBody2D

# Exportovaná scéna projektilu – nastavuje sa v editore
@export var projectile_scene: PackedScene

# Parametre pohybu a otáčania
var speed = 90                 # Maximálna rýchlosť dopredu
var reverse_speed = 50        # Maximálna spätná rýchlosť (aktuálne sa nepoužíva osobitne)
var acceleration = 100        # Zrýchlenie
var deceleration = 200        # Spomalenie
var rotation_speed = 1.5      # Rýchlosť rotácie
var current_speed = 0.0       # Aktuálna rýchlosť

func _physics_process(delta):
	var input_direction = 0.0

	# Pohyb dopredu / dozadu
	if Input.is_action_pressed("ui_up"):
		input_direction = 1
	elif Input.is_action_pressed("ui_down"):
		input_direction = -0.5

	# Zrýchľovanie alebo spomaľovanie na základe vstupu
	if input_direction != 0:
		current_speed = move_toward(current_speed, input_direction * speed, acceleration * delta)
	else:
		current_speed = move_toward(current_speed, 0, deceleration * delta)

	# Otáčanie lode doľava/doprava
	if Input.is_action_pressed("ui_left"):
		rotation -= rotation_speed * delta
	if Input.is_action_pressed("ui_right"):
		rotation += rotation_speed * delta

	# Výpočet vektoru rýchlosti na základe rotácie a aktuálnej rýchlosti
	velocity = Vector2.UP.rotated(rotation) * current_speed

	# Obmedzenie pohybu lode len na dolnú polovicu obrazovky
	var screen_size = get_viewport_rect().size
	var margin = 10
	position.y = clamp(position.y, screen_size.y / 2 + margin, screen_size.y - margin)
	position.x = clamp(position.x, margin, screen_size.x - margin)

	# Posunutie lode
	move_and_slide()

	# Výstrel po stlačení príslušnej akcie
	if Input.is_action_just_pressed("shoot_auto"):
		shoot_from_top_facing_side()

# Funkcia na výstrel do bočnej strany (ľavá alebo pravá – bližšia k vrchu)
func shoot_from_top_facing_side():
	var ammo_manager = get_node_or_null("/root/Main/AmmoUI")
	if ammo_manager == null:
		print("⚠️ Ammo manager not found")
		return

	# Kontrola nábojov hráča 1
	if ammo_manager.player1_ammo.size() <= 0:
		print("Player1: Out of ammo")
		return

	ammo_manager.use_ammo(1)

	if projectile_scene == null:
		return

	# Vypočítanie uhla výstrelu na ľavú a pravú stranu lode
	var left_angle = rotation - PI / 2
	var right_angle = rotation + PI / 2

	# Určenie, ktorá strana je viac „hore“ podľa orientácie lode
	var up_vector = Vector2.UP
	var left_dot = up_vector.dot(Vector2.UP.rotated(left_angle))
	var right_dot = up_vector.dot(Vector2.UP.rotated(right_angle))

	var shot_angle = left_angle if left_dot > right_dot else right_angle
	var shot_direction = Vector2.UP.rotated(shot_angle)

	# Efekt výstrelu – záblesk + dym
	var muzzle_flash = preload("res://muzzle_flash.tscn").instantiate()
	muzzle_flash.global_position = global_position + shot_direction.normalized() * 32
	muzzle_flash.rotation = shot_angle

	get_tree().get_current_scene().add_child(muzzle_flash)

	muzzle_flash.get_node("ExplosionEffect").emitting = true
	muzzle_flash.get_node("SmokeEffect").emitting = true

	# Vytvorenie projektilu v smere výstrelu
	var projectile = projectile_scene.instantiate()
	projectile.direction = shot_direction
	projectile.rotation = shot_angle
	projectile.global_position = global_position + shot_direction.normalized() * 32

	get_tree().get_current_scene().add_child(projectile)
