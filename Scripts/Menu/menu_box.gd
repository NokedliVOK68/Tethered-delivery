extends CharacterBody2D


const SPEED = 300.0
var conveyor_velocity = 0.0

func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity += get_gravity() * delta

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	velocity.x += conveyor_velocity
	move_and_slide()
