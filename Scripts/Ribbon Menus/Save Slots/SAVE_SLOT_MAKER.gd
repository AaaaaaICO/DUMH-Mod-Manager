extends Panel

@onready var SAVE_SLOT_PICKER = "res://Scenes/PREFABS/Ribbon Menus/Save Slots/SAVE_SLOT_PICKER.tscn"

var SAVE_SLOT_TEMPLATE = {
	"SLOT_NAME": "",
	"SLOT_GAME_PATH": "",
	"SLOT_MODS_FOLDER_PATH": "",
}

func _ready() -> void:
	%BTN_ADD.pressed.connect(CREATE_NEW_SLOT)
	for SLOT in Global.SAVE_DATA["SAVE_SLOTS"]:
		CREATE_SLOT_PICKER(SLOT)
func CREATE_NEW_SLOT_OLD():
	var SAVE_SLOT = SAVE_SLOT_TEMPLATE
	if(%TE_SSN.text != "" and %TE_GP.text != "" and %TE_MP.text != ""):
		var EXISTS = false
		for SLOT in Global.SAVE_DATA["SAVE_SLOTS"]:
			var SLOTNAME = SLOT["SLOT_NAME"]
			if(SLOTNAME == %TE_SSN.text):
				EXISTS = true
		if(!EXISTS):
			SAVE_SLOT["SLOT_NAME"] = %TE_SSN.text
			SAVE_SLOT["SLOT_GAME_PATH"] = %TE_GP.text
			SAVE_SLOT["SLOT_MODS_FOLDER_PATH"] = %TE_MP.text
			Global.SAVE_DATA["SAVE_SLOTS"].append(SAVE_SLOT)
			print("Save slot created")
		else:
			print("Save slot needs a unique name")
	else:
		print("Save slot needs a name")

func CREATE_NEW_SLOT():
	Global.SAVE_DATA["GAME_PATH"] = ""
	Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] = ""
	Global.SAVE_DATA["NEXT_INDEX_SLOT"] = 0
	get_tree().get_root().get_node("MASTER").SAVE_SLOTS_CLOSED()
	get_tree().get_root().get_node("MASTER").Start()

func CREATE_SLOT_PICKER(DATA):
	var PICKER = load(SAVE_SLOT_PICKER).instantiate()
	PICKER.DATA = DATA 
	get_parent().add_child(PICKER)
