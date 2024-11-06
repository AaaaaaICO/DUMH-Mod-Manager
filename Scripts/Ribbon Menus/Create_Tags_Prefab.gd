extends Panel

func ADD_BTN_PRESSED() -> void:
	var NEW_TAG_NAME = $VBoxContainer/MarginContainer/HBoxContainer/TextEdit.get_text()
	if(NEW_TAG_NAME):
		var FILE_DATA = FileAccess.open(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/CONFIG.json",  FileAccess.READ);
		var JSON_STRING = FILE_DATA.get_as_text()
		var FILE_AS_DICT = JSON.parse_string(JSON_STRING)
		var CAN_CREATE_TAG = true
		for X in FILE_AS_DICT["TAGS"]:
			if(X[0] == NEW_TAG_NAME):
				print("A tag called " + NEW_TAG_NAME + " already exists")
				CAN_CREATE_TAG = false
		if(CAN_CREATE_TAG):
			FILE_AS_DICT["TAGS"].append([$VBoxContainer/MarginContainer/HBoxContainer/TextEdit.get_text(), $VBoxContainer/Control/ColorPicker.get_pick_color().to_html()])
			var Data_FILE = FileAccess.open(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/CONFIG.json",  FileAccess.WRITE)
			JSON_STRING = JSON.stringify(FILE_AS_DICT)
			Data_FILE.store_line(JSON_STRING)
		get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().BTN_TAGS_PRESSED()
	else:
		print("Tag must have a name")
