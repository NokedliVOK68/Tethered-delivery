extends Area2D

@onready var tp_start = $"../TP_Start"
@onready var box: CharacterBody2D = $"../Box"


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		box.visible = false
		box.global_position = tp_start.global_position
		await get_tree().create_timer(0.2).timeout
		box.visible = true
