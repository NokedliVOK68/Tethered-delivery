extends RichTextLabel


func _ready() -> void:
	text = "Hi there!"

func _process(_delta: float) -> void:
	pass


func _on_guide_text_1_body_entered(body: Node2D) -> void:
	if body is Player:
		text = "A/D to move and space to jump!"


func _on_guide_text_2_body_entered(body: Node2D) -> void:
	if body is Player:
		text = "You can pick up the box by pressing E! Once it's picked up, use E again to throw it! Also use E to interact with things!"


func _on_guide_text_3_body_entered(body: Node2D) -> void:
	if body is Player:
		text = "You can pull it by pressing Q! Try standing on it too!"


func _on_guide_text_4_body_entered(body: Node2D) -> void:
	if body is Player:
		text = "To progress, just get the box to the van!"
