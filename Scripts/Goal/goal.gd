extends Area2D


@export_file("*.tscn") var next_level


func _on_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		if next_level != "":
			get_tree().change_scene_to_file(next_level)
