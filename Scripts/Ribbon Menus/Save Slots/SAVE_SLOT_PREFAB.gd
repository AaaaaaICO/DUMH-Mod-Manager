extends Panel



var DATA
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	%BTN_OPEN.pressed.connect(BTN_OPEN_PRESSED.bind())
	%BTN_DELETE.pressed.connect(BTN_DELETE_PRESSED.bind())
	
	
	
	%LBL_Title.text = DATA["SLOT_NAME"]
	%TextEdit.placeholder_text = DATA["SLOT_NAME"]
	
	
func BTN_OPEN_PRESSED():
	if(DATA):
		Global.SAVE_DATA["GAME_PATH"] = DATA["SLOT_GAME_PATH"]
		Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] = DATA["SLOT_MODS_FOLDER_PATH"]
		Global.SAVE_DATA["NEXT_INDEX_SLOT"] = 0
		get_tree().get_root().get_node("MASTER").SAVE_SLOTS_CLOSED()
		get_tree().get_root().get_node("MASTER").Start()
func BTN_DELETE_PRESSED():
	get_tree().get_root().get_node("MASTER").SAVE_SLOTS_CLOSED()
	get_tree().get_root().get_node("MASTER").Start()
	for SLOT in Global.SAVE_DATA["SAVE_SLOTS"]:
		if(SLOT == DATA):
			Global.SAVE_DATA["SAVE_SLOTS"].erase(SLOT)
