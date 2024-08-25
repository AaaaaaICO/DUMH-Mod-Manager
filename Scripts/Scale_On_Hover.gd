extends Button


@export var UnHoverSize : Vector2
@export var UnHoverColor : Color
@export var UnHoverDur : float
@export var HoverSize : Vector2
@export var HoverDur : float
@export var HoverColor : Color

func _on_mouse_entered():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", HoverSize, HoverDur).set_trans(Tween.TRANS_QUAD)
	tween.parallel().tween_property(self, "modulate", HoverColor, HoverDur).set_trans(Tween.TRANS_QUAD)

func _on_mouse_exited():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", UnHoverSize, UnHoverDur).set_trans(Tween.TRANS_QUAD)
	tween.parallel().tween_property(self, "modulate", UnHoverColor, UnHoverDur).set_trans(Tween.TRANS_QUAD)
