extends Panel

var NAME = ""
var LIST = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var FILE_DATA = FileAccess.open(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/CONFIG.json",  FileAccess.READ);
	var JSON_STRING = FILE_DATA.get_as_text()
	var FILE_AS_DICT = JSON.parse_string(JSON_STRING)
	var PRESETS = FILE_AS_DICT["PRESETS"]
	for X in PRESETS:
		if(X[0] == NAME):
			LIST = X[1]
			print(LIST)
	$MarginContainer/VBoxContainer/HBoxContainer/Panel/LBL_NUM.set_text(str(len(LIST)))
	$MarginContainer/VBoxContainer/Label.set_text(NAME)


func BTN_DELETE_PRESSED() -> void:
	var FILE_DATA = FileAccess.open(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/CONFIG.json",  FileAccess.READ);
	var JSON_STRING = FILE_DATA.get_as_text()
	var FILE_AS_DICT = JSON.parse_string(JSON_STRING)
	var PRESETS = FILE_AS_DICT["PRESETS"]
	for X in PRESETS:
		if(X[0] == NAME):
			PRESETS.erase(X)
	var Data_FILE = FileAccess.open(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/CONFIG.json",  FileAccess.WRITE)
	JSON_STRING = JSON.stringify(FILE_AS_DICT)
	Data_FILE.store_line(JSON_STRING)
	Global.POPULATE = true


func BTN_APPLY_PRESSED() -> void:
	var LIST = await Global.LIST_MODS_BY_INDEX()
	Global.MODS_TO_APPLY = []
	Global.MODS_TO_UNAPPLY = []
	Global.MODS_APPLYED = []
	for NAME in LIST:
		DirAccess.remove_absolute(Global.SAVE_DATA["GAME_PATH"] + r"\RED\Content\Paks\~MODS\DUMH"+"/"+NAME[0]+".pak")
		DirAccess.remove_absolute(Global.SAVE_DATA["GAME_PATH"] + r"\RED\Content\Paks\~MODS\DUMH"+"/"+NAME[0]+".sig")
		print("Removed mod " + NAME[0])
	var FILE_DATA = FileAccess.open(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/CONFIG.json",  FileAccess.READ);
	var JSON_STRING = FILE_DATA.get_as_text()
	var FILE_AS_DICT = JSON.parse_string(JSON_STRING)
	var PRESETS = FILE_AS_DICT["PRESETS"]
	for X in PRESETS:
		if(X[0] == NAME):
			LIST = X[1]
			Global.MODS_TO_APPLY = []
			Global.MODS_TO_UNAPPLY = []
			Global.MODS_APPLYED = []
			for NAME in LIST:
				await DirAccess.copy_absolute(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"]+"/"+NAME+"/"+NAME+".pak", Global.SAVE_DATA["GAME_PATH"] + r"\RED\Content\Paks\~MODS\DUMH"+"/"+NAME+".pak")
				await DirAccess.copy_absolute(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"]+"/"+NAME+"/"+NAME+".sig", Global.SAVE_DATA["GAME_PATH"] + r"\RED\Content\Paks\~MODS\DUMH"+"/"+NAME+".sig")
				print("Applyed mod " + NAME)
			Global.MODS_APPLYED = []
			var DA = DirAccess.open(Global.SAVE_DATA["GAME_PATH"] + r"\RED\Content\Paks\~MODS\DUMH")
			for FILE in DA.get_files():
				if(FILE.contains(".pak")):
					Global.MODS_APPLYED.append(FILE.left(FILE.length() - 4))
			Global.POPULATE = true
