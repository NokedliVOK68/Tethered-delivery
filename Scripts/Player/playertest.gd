extends RigidBody2D


@export var move_speed := 200.0
@export var accel := 10.0
@export var jump_force := 400.0

var move_input := 0.0
var is_grounded := false

func _physics_process(delta):
	# Get input
	move_input = Input.get_axis("ui_left", "ui_right")

	# Smooth horizontal movement
	var target_vel_x = move_input * move_speed
	linear_velocity.x = lerp(linear_velocity.x, target_vel_x, accel * delta)

	# Jump
	if is_grounded and Input.is_action_just_pressed("jump"):
		apply_impulse(Vector2(0, -jump_force))

func _integrate_forces(state):
	# Simple ground check using contacts
	is_grounded = false
	
	for i in range(state.get_contact_count()):
		var normal = state.get_contact_local_normal(i)
		if normal.dot(Vector2.UP) > 0.7:
			is_grounded = true
