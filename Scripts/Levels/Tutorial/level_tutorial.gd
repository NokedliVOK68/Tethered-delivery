extends Node2D


@onready var goal: Area2D = $Goal


func _ready() -> void:
	goal.scale.x = -2
