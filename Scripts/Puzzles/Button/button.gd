extends Area2D

@onready var up: Sprite2D = $Up
@onready var down: Sprite2D = $Down
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

@export var door: Node2D

var overlapping = false

func _ready() -> void:
	down.visible = false

func play_door_sound():
	audio_stream_player_2d.play()

func delete_door():
	if overlapping:
		if is_instance_valid(door):
			up.visible = false
			down.visible = true
			play_door_sound()
			door.queue_free()
		else:
			return

func _process(_delta: float) -> void:
	delete_door()


func _on_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		overlapping = true
	else:
		overlapping = false
