extends MarginContainer

signal Pressed(RESULT)

func _ready() -> void:
	%CDC_BTN_CONFIRM.pressed.connect(CONFIRMED)
	%CDC_BTN_CANCEL.pressed.connect(CANCEL)	

func CONFIRMED():
	Pressed.emit(true)

func CANCEL():
	Pressed.emit(false)
