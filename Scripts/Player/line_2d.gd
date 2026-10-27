extends Line2D

@export var player: Node2D
@export var box: Node2D

func _process(_delta):
	# Clear the old points
	clear_points()
	
	# Use to_local so the line draws correctly regardless of where the node is in the tree
	add_point(to_local(player.global_position))
	add_point(to_local(box.global_position))
