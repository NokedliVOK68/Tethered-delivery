class_name Player extends CharacterBody2D

@onready var rope = $DampedSpringJoint2D
@onready var hold_pos: Marker2D = $HoldPos2D
@onready var progress_bar: TextureProgressBar = $ProgressBar
#@onready var box_cast: RayCast2D = $RayCast2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D


var conveyor_velocity = 0.0

@export var speed = 300.0
@export var jump = -400.0
@export var box: RigidBody2D
var push_force = 80

var picked_up = false
var can_move = true
var moving = false
var can_pull = true
var pulling = false

var rope_max_length = 200

var launch_direction = Vector2.ZERO
var launch_speed = 0

var hold_time = 0.0
var add_time = 0.0
var add_time_tick = 0.25
@export var max_hold_time = 1

#func is_on_box() -> bool:
	#if box_cast.is_colliding():
		#var collider = box_cast.get_collider()
		#
		#if collider.is_in_group("box"):
			#return true
	#
	#return false

func _ready() -> void:
	box.gravity_scale = 1.0
	rope.rest_length = 50

func play_jump_sound():
	audio_stream_player_2d.play()

func reload_scene():
	if Input.is_action_just_pressed("ui_reload_scene"):
		get_tree().reload_current_scene()

func launchdir():
	var input_dir := Input.get_axis("ui_left", "ui_right")
	
	if Input.is_action_pressed("ui_right"):
		launch_direction = Vector2(1.5, -1.0).normalized()
	elif Input.is_action_pressed("ui_left"):
		launch_direction = Vector2(-1.5, -1.0).normalized()
	
	if input_dir > 0:
		progress_bar.scale.x = 2
	elif input_dir < 0:
			progress_bar.scale.x = -2

func movement(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
		animated_sprite_2d.play("Fall")
	
	if can_move:
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			play_jump_sound()
			velocity.y = jump
	
		var direction := Input.get_axis("ui_left", "ui_right")
		if direction:
			moving = true
			velocity.x = direction * speed
			if not is_on_floor():
				animated_sprite_2d.play("Fall")
			else:
				animated_sprite_2d.play("Run")
			animated_sprite_2d.flip_h = direction < 0
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			moving = false
			if is_on_floor():
				animated_sprite_2d.play("Idle")

	
	velocity.x += conveyor_velocity
	move_and_slide()
	
	$AnchorPoint.global_position = global_position
	
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)
			
	
	#if is_on_box():
		#box.physics_material_override.bounce = 0.0
	#else:
		#box.physics_material_override.bounce = 0.4

func pull(delta):
	if is_on_floor() && can_pull && !moving:
	
		if Input.is_action_pressed("ui_pull"):
			can_move = false
			pulling = true
			
			box.gravity_scale = 0.5
			
			var dir = (global_position - box.global_position)
			var distance = dir.length()
			
			if distance > 1:
				box.apply_central_force(dir * 25)
				box.apply_central_force(Vector2(0, -30))
				if rope.rest_length <= 200:
					rope.rest_length = clamp(rope.rest_length + (500 * delta), 0, 500)
		
		if Input.is_action_just_released("ui_pull"):
			can_move = true
			pulling = false
			
			box.gravity_scale = 1.0
			
			rope.rest_length = clamp(rope.rest_length + (1000 * delta), 0, 1000)
			rope.rest_length = 50
	
	if pulling:
		if animated_sprite_2d.animation != "Pull":
			animated_sprite_2d.play("Pull")

func pickup():
		if Input.is_action_just_pressed("ui_interact"):
			var distance = global_position.distance_to(box.global_position)
			if distance <= 150 && !picked_up:
				animated_sprite_2d.play("Hold")
				picked_up = true
				box.global_position = hold_pos.global_position 
				box.angular_velocity = 0 
				box.freeze = true
				box.continuous_cd = RigidBody2D.CCD_MODE_DISABLED
				box.collision_layer = 0
				box.collision_mask = 0

func throw(delta):
	if picked_up: #set launchdir, progress bar and movement once charging the throw
		launchdir()
		can_pull = false
		pulling = false
		progress_bar.visible = true
		if Input.is_action_pressed("ui_interact"):
			hold_time += delta
			add_time += delta
			progress_bar.value = hold_time
			velocity = Vector2.ZERO
			can_move = false
			if hold_time < max_hold_time:
				if add_time >= add_time_tick:
					launch_speed += 275
					add_time -= add_time_tick

		if Input.is_action_just_released("ui_interact"): #releasing the button will launch the box
			progress_bar.value = 0
			if hold_time >  0.2:
				box.linear_velocity = launch_direction * launch_speed 
				box.freeze = false
				picked_up = false
				can_move = true
				hold_time = 0.0
				can_pull = true
				progress_bar.visible = false
				box.continuous_cd = RigidBody2D.CCD_MODE_CAST_SHAPE
				box.collision_layer = (1 << 0) | (1 << 1)
				box.collision_mask = 1

	
	if hold_time > max_hold_time: #lets go of the box once the hold time is over a second
		hold_time = max_hold_time
		box.linear_velocity = launch_direction * launch_speed 
		box.freeze = false
		picked_up = false
		can_move = true
		hold_time = 0.0
		progress_bar.visible = false
		box.continuous_cd = RigidBody2D.CCD_MODE_CAST_SHAPE
		box.collision_layer = (1 << 0) | (1 << 1)
		box.collision_mask = 1
	
	if hold_time == 0.0:
		launch_speed = 0

func _physics_process(delta: float) -> void:
	#is_on_box()
	movement(delta)
	pull(delta)
	pickup()
	throw(delta)
	reload_scene()
	
	#print(rope.rest_length)
