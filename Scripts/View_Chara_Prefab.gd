extends Panel

var CHARA_NAME = ""

func _ready() -> void:
	$VBoxContainer/LBL_Title.set_text(CHARA_NAME)
	$VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/TextEdit.set_placeholder(CHARA_NAME)


func ON_EXIT() -> void:
	var NEW_TEXT = $VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/TextEdit.get_text()
	if(NEW_TEXT):
		var FILE_DATA = FileAccess.open(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/CONFIG.json",  FileAccess.READ);
		var JSON_STRING = FILE_DATA.get_as_text()
		var FILE_AS_DICT = JSON.parse_string(JSON_STRING)
		var CHARAS = FILE_AS_DICT["CHARACTERS"]
		var CHARA_EXISTS = false
		for X in range(0, len(CHARAS)): # pls tell me why this works and what i did before didnt
			if(CHARAS[X] == CHARA_NAME):
				CHARAS[X] = NEW_TEXT
		FILE_AS_DICT["CHARACTERS"] = CHARAS
		var Data_FILE = FileAccess.open(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/" + "/CONFIG.json",  FileAccess.WRITE)
		JSON_STRING = JSON.stringify(FILE_AS_DICT)
		Data_FILE.store_line(JSON_STRING)
		Global.POPULATE = true
func BTN_DELETE_PRESSED() -> void:
	var UPDATE = func(FILE_AS_DICT):
		var Data_FILE = FileAccess.open(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/" + "/CONFIG.json",  FileAccess.WRITE)
		var JSON_STRING = JSON.stringify(FILE_AS_DICT)
		Data_FILE.store_line(JSON_STRING)
		
	var FILE_DATA = FileAccess.open(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/CONFIG.json",  FileAccess.READ);
	var JSON_STRING = FILE_DATA.get_as_text()
	var FILE_AS_DICT = JSON.parse_string(JSON_STRING)
	var CHARAS = FILE_AS_DICT["CHARACTERS"]
	for X in CHARAS:
		if(X == CHARA_NAME):
			CHARAS.erase(X)
	FILE_AS_DICT["CHARACTERS"] = CHARAS
	await UPDATE_BTNDP(FILE_AS_DICT)
	Global.POPULATE = true
	get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().BTN_CHARA_PRESSED()
	
func UPDATE_BTNDP(FILE_AS_DICT): # aaahhhhhhhhhhhhhhhhhhh sudo fix
	var Data_FILE = FileAccess.open(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/" + "/CONFIG.json",  FileAccess.WRITE)
	var JSON_STRING = JSON.stringify(FILE_AS_DICT)
	Data_FILE.store_line(JSON_STRING)
