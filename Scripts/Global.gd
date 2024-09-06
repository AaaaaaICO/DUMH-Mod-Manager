extends Node

var SAVE_DATA = {
	"GAME_PATH" : "",
	"USER_MODS_FOLDER_PATH": "",
	"USER_MODS_PRESETS" : [],
	"NEXT_INDEX_SLOT": 0
}
var SAVE_LOCATION = "user://saves.cfg"

var MODS_APPLYED = []
var MODS_TO_APPLY = []
var MODS_TO_UNAPPLY = []

var SETTINGS_WINDOW_OPEN = false

var POPULATE = false
var POPULATE_TAGS = []
var POPULATE_CHARAS = []
var REFRESH_WINDOW = false
var CAN_REFRESH = false
func _ready():
	pass

func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("REFRESH") and CAN_REFRESH):
		REFRESH_WINDOW = true

func SAVE_SAVE():
	print("SAVING")
	var config = ConfigFile.new()
	var configFile = config.load(SAVE_LOCATION)
	config.set_value("USER", "SAVE_DATA", SAVE_DATA)
	config.save(SAVE_LOCATION)
	print("SAVING---FINISHED")
	
func LOAD_SAVE():
	var STARTING_DATA = {
		"GAME_PATH" : "",
		"USER_MODS_FOLDER_PATH": "",
		"USER_MODS_PRESETS" : [],
		"NEXT_INDEX_SLOT": 0
	}
	var config = ConfigFile.new()
	var configFile = config.load(SAVE_LOCATION)
	var TEMP_SAVE_DATA = config.get_value("USER", "SAVE_DATA")
	if(TEMP_SAVE_DATA):
		SAVE_DATA = TEMP_SAVE_DATA
		print("Next index slot : " + str(SAVE_DATA["NEXT_INDEX_SLOT"]))
	else:
		SAVE_DATA = STARTING_DATA

func HARD_RESET():
	var config = ConfigFile.new()
	var configFile = config.load(SAVE_LOCATION)
	if configFile != OK:
		pass
	config.clear()
	config.save(SAVE_LOCATION)

func LIST_MODS_BY_INDEX():
	var INDEX_MODS_LIST = []
	var DA = DirAccess.open(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"])
	for DIR in DA.get_directories():
		var FILE_DATA = FileAccess.open(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/" + DIR + "/" + "DATA.json", FileAccess.READ)
		var JSON_STRING = FILE_DATA.get_as_text()
		var FILE_AS_DICT = JSON.parse_string(JSON_STRING)
		var INDEX = FILE_AS_DICT["INDEX"]
		INDEX_MODS_LIST.append([DIR, INDEX])
	INDEX_MODS_LIST.sort_custom(func(a, b): return a[1] < b[1])
	return INDEX_MODS_LIST
func DEFRAGMENT_INDEX_VALUES():
	var INDEX_MODS_LIST = await LIST_MODS_BY_INDEX()
	var DEFRAGED_INDEX_MODS_LIST = []
	for ITEM in range(0, len(INDEX_MODS_LIST)): # 0,0,0  
		DEFRAGED_INDEX_MODS_LIST.append([INDEX_MODS_LIST[ITEM][0], ITEM+1])
	for ITEM in DEFRAGED_INDEX_MODS_LIST:
		var FILE_DATA = FileAccess.open(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/" + ITEM[0] + "/" + "DATA.json", FileAccess.READ);
		var JSON_STRING = FILE_DATA.get_as_text()
		var FILE_AS_DICT = JSON.parse_string(JSON_STRING)
		FILE_AS_DICT["INDEX"] = ITEM[1]
		var Data_FILE = FileAccess.open(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/" + ITEM[0] + "/" + "DATA.json",  FileAccess.WRITE)
		JSON_STRING = JSON.stringify(FILE_AS_DICT)
		Data_FILE.store_line(JSON_STRING)
	if(len(DEFRAGED_INDEX_MODS_LIST) <= 0):
		SAVE_DATA["NEXT_INDEX_SLOT"] = 1
	else:
		SAVE_DATA["NEXT_INDEX_SLOT"] = DEFRAGED_INDEX_MODS_LIST[len(DEFRAGED_INDEX_MODS_LIST)-1][1] + 1
	return DEFRAGED_INDEX_MODS_LIST

func ADD_INDEX_TO_MOD(WHERE):
	var CUSTOM_FIND_MULTI_DIM = func(WHAT, LIST, ARRAYDEPTH):
		var INDEX = 0
		for X in LIST:
			if(X[ARRAYDEPTH] == WHAT):
				return INDEX
			INDEX += 1
			
	var INDEX_MODS_LIST = await DEFRAGMENT_INDEX_VALUES()
	var INDENT = CUSTOM_FIND_MULTI_DIM.call(WHERE, INDEX_MODS_LIST, 0)
	var LOOP = 0
	for X in range(INDENT, len(INDEX_MODS_LIST)):
		if(LOOP == 1):
			INDEX_MODS_LIST[X][1] -= 1
		else:
			INDEX_MODS_LIST[X][1] += 1
		LOOP += 1
	for ITEM in INDEX_MODS_LIST:
		var FILE_DATA = FileAccess.open(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/" + ITEM[0] + "/" + "DATA.json", FileAccess.READ);
		var JSON_STRING = FILE_DATA.get_as_text()
		var FILE_AS_DICT = JSON.parse_string(JSON_STRING)
		FILE_AS_DICT["INDEX"] = ITEM[1]
		var Data_FILE = FileAccess.open(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/" + ITEM[0] + "/" + "DATA.json",  FileAccess.WRITE)
		JSON_STRING = JSON.stringify(FILE_AS_DICT)
		Data_FILE.store_line(JSON_STRING)
	await DEFRAGMENT_INDEX_VALUES()

func SUBTRACT_INDEX_TO_MOD(WHERE):
	var CUSTOM_FIND_MULTI_DIM = func(WHAT, LIST, ARRAYDEPTH):
		var INDEX = 0
		for X in LIST:
			if(X[ARRAYDEPTH] == WHAT):
				return INDEX
			INDEX += 1
			
	var INDEX_MODS_LIST = await DEFRAGMENT_INDEX_VALUES()
	var INDENT = CUSTOM_FIND_MULTI_DIM.call(WHERE, INDEX_MODS_LIST, 0)
	var LOOP = 0 # 0, 2, 1, 4
	if(INDENT != 0):
		INDEX_MODS_LIST[INDENT][1] -= 1
		INDEX_MODS_LIST[INDENT-1][1] += 1
		for ITEM in INDEX_MODS_LIST:
			var FILE_DATA = FileAccess.open(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/" + ITEM[0] + "/" + "DATA.json", FileAccess.READ);
			var JSON_STRING = FILE_DATA.get_as_text()
			var FILE_AS_DICT = JSON.parse_string(JSON_STRING)
			FILE_AS_DICT["INDEX"] = ITEM[1]
			var Data_FILE = FileAccess.open(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/" + ITEM[0] + "/" + "DATA.json",  FileAccess.WRITE)
			JSON_STRING = JSON.stringify(FILE_AS_DICT)
			Data_FILE.store_line(JSON_STRING)
		await DEFRAGMENT_INDEX_VALUES()

func RETURN_TAG_COLOR(TAG_NAME):
	var FILE_DATA = FileAccess.open(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/CONFIG.json",  FileAccess.READ);
	var JSON_STRING = FILE_DATA.get_as_text()
	var FILE_AS_DICT = JSON.parse_string(JSON_STRING)
	var TAGS = FILE_AS_DICT["TAGS"]
	for X in TAGS:
		if(X[0] == TAG_NAME):
			return X[1]

func CHECK_TAG_EXISTS(TAG_NAME):
	var FILE_DATA = FileAccess.open(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/CONFIG.json",  FileAccess.READ);
	var JSON_STRING = FILE_DATA.get_as_text()
	var FILE_AS_DICT = JSON.parse_string(JSON_STRING)
	var TAGS = FILE_AS_DICT["TAGS"]
	var TAG_EXISTS = false
	for X in TAGS:
		if(X[0] == TAG_NAME):
			TAG_EXISTS = true
	return TAG_EXISTS
func CHECK_CHARA_EXISTS(CHARA_NAME):
	var FILE_DATA = FileAccess.open(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/CONFIG.json",  FileAccess.READ);
	var JSON_STRING = FILE_DATA.get_as_text()
	var FILE_AS_DICT = JSON.parse_string(JSON_STRING)
	var CHARAS = FILE_AS_DICT["CHARACTERS"]
	var CHARA_EXISTS = false
	for X in CHARAS:
		if(X == CHARA_NAME):
			CHARA_EXISTS = true
	return CHARA_EXISTS


func CHECK_PRESET_EXISTS(PRESET_NAME):
	var FILE_DATA = FileAccess.open(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/CONFIG.json",  FileAccess.READ);
	var JSON_STRING = FILE_DATA.get_as_text()
	var FILE_AS_DICT = JSON.parse_string(JSON_STRING)
	var PRESETS = FILE_AS_DICT["PRESETS"]
	var PRESET_EXISTS = false
	for X in PRESETS:
		if(X[0] == PRESET_NAME):
			PRESET_EXISTS = true
	return PRESET_EXISTS
