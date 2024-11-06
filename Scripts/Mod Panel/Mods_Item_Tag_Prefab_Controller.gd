extends Panel

var TAG_NAME = ""


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("LBL").set_text(TAG_NAME)
