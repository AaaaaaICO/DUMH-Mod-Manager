extends Panel

var TAG_NAME = ""

func _ready() -> void:
	$VBoxContainer/LBL_Title.set_text(TAG_NAME)
	$VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/TextEdit.set_placeholder(TAG_NAME)


func ON_EXIT() -> void:
	var NEW_TEXT = $VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/TextEdit.get_text()
	var OLD_NAME = TAG_NAME
	if(NEW_TEXT):
		var FILE_DATA = FileAccess.open(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/CONFIG.json",  FileAccess.READ);
		var JSON_STRING = FILE_DATA.get_as_text()
		var FILE_AS_DICT = JSON.parse_string(JSON_STRING)
		var TAGS = FILE_AS_DICT["TAGS"]
		var TAG_EXISTS = false
		for X in TAGS:
			if(X[0] == TAG_NAME):
				X[0] = NEW_TEXT
		FILE_AS_DICT["TAGS"] = TAGS
		var Data_FILE = FileAccess.open(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/" + "/CONFIG.json",  FileAccess.WRITE)
		JSON_STRING = JSON.stringify(FILE_AS_DICT)
		Data_FILE.store_line(JSON_STRING)
		
		var DA = DirAccess.open(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"])
		for DIR in DA.get_directories():
			FILE_DATA = FileAccess.open(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/" + DIR + "/" + "DATA.json", FileAccess.READ)
			JSON_STRING = FILE_DATA.get_as_text()
			FILE_AS_DICT = JSON.parse_string(JSON_STRING)
			for TAG in FILE_AS_DICT["TAGS"]:
				if(TAG == OLD_NAME):
					FILE_AS_DICT["TAGS"].erase(TAG)
					FILE_AS_DICT["TAGS"].append(NEW_TEXT)
			Data_FILE = FileAccess.open(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/" + DIR + "/" + "DATA.json",  FileAccess.WRITE)
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
	var TAGS = FILE_AS_DICT["TAGS"]
	for X in TAGS:
		if(X[0] == TAG_NAME):
			TAGS.erase(X)
	FILE_AS_DICT["TAGS"] = TAGS
	await UPDATE_BTNDP(FILE_AS_DICT)
	Global.POPULATE = true
	get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().BTN_TAGS_PRESSED()

func UPDATE_BTNDP(FILE_AS_DICT): # aaahhhhhhhhhhhhhhhhhhh sudo fix
	var Data_FILE = FileAccess.open(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/" + "/CONFIG.json",  FileAccess.WRITE)
	var JSON_STRING = JSON.stringify(FILE_AS_DICT)
	Data_FILE.store_line(JSON_STRING)
