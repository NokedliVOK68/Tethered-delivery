class_name ConveyorBelt extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $"../AnimatedSprite2D"
@onready var player = get_tree().get_first_node_in_group("player")

@export var Hspeed = 50
var objects_array: Array[Node2D] = []
var objects_speed: Array[float] = []

func _ready() -> void:
	animated_sprite_2d.play("default")
	
	set_physics_process(false)
	body_entered.connect(_object_entered)
	body_exited.connect(_object_exited)


func _physics_process(_delta: float) -> void:
	for i in objects_array.size():
		if objects_array[i].is_on_floor() and objects_speed[i] != Hspeed:
			objects_array[i].conveyor_velocity += Hspeed
			objects_speed[i] = Hspeed
		elif !objects_array[i].is_on_floor() and objects_speed[i] != 0.0:
			objects_array[i].conveyor_velocity -= Hspeed
			objects_speed[i] = 0.0

func _object_entered(object:Node2D):
	if "conveyor_velocity" in object:
		objects_array.append(object)
		objects_speed.append(0.0)
	
	if !objects_array.is_empty():
		set_physics_process(true)

func _object_exited(object:Node2D):
	if "conveyor_velocity" in object and objects_array.has(object):
		var object_pos: int = objects_array.find(object)
		if objects_speed[object_pos] != 0.0:
			objects_array[object_pos].conveyor_velocity -= Hspeed
		objects_array.remove_at(object_pos)
		objects_speed.remove_at(object_pos)
		
	if objects_array.is_empty():
		set_physics_process(false)
