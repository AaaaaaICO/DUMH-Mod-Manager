extends Panel

func ADD_BTN_PRESSED() -> void:
	var NEW_CHARA_NAME = $VBoxContainer/MarginContainer/HBoxContainer/TextEdit.get_text()
	if(NEW_CHARA_NAME):
		var FILE_DATA = FileAccess.open(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/CONFIG.json",  FileAccess.READ);
		var JSON_STRING = FILE_DATA.get_as_text()
		var FILE_AS_DICT = JSON.parse_string(JSON_STRING)
		var CAN_CREATE_CHARA = true
		for X in FILE_AS_DICT["CHARACTERS"]:
			if(X == NEW_CHARA_NAME):
				print("A character called " + NEW_CHARA_NAME + " already exists")
				CAN_CREATE_CHARA = false
		if(CAN_CREATE_CHARA):
			FILE_AS_DICT["CHARACTERS"].append($VBoxContainer/MarginContainer/HBoxContainer/TextEdit.get_text())
			var Data_FILE = FileAccess.open(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/CONFIG.json",  FileAccess.WRITE)
			JSON_STRING = JSON.stringify(FILE_AS_DICT)
			Data_FILE.store_line(JSON_STRING)
		get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().BTN_CHARA_PRESSED()
	else:
		print("Character must have a name")
