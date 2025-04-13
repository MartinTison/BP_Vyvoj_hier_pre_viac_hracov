extends Area2D
@export var is_island: bool = true

var speed = 200
var direction = Vector2.ZERO

func _physics_process(delta):
	print("Speed:", speed)
	position += direction * speed * delta

	if position.x < -100 or position.x > 1400 or position.y < -100 or position.y > 800:
		queue_free()

func _on_area_entered(area):
	print("Zásah:", area.name)

	set_deferred("monitoring", false)

	if area.name == "Hitbox":
		get_node("/root/Main/UI").remove_life(1)
		queue_free()
	elif area.name == "Hitbox2":
		get_node("/root/Main/UI").remove_life(2)
		queue_free()
