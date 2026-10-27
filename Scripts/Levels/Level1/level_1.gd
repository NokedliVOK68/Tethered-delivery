extends Node2D

@onready var goal: Area2D = $Goal
@onready var hint_text: RichTextLabel = $"Hint text"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	goal.scale.x = -2
	await get_tree().create_timer(4).timeout
	hint_text.visible = false
