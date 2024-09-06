extends Control

@onready var INPUTBLOCKER = get_node("__INPUTBLOCKER__")
@onready var INPUTBLOCKER_GET_GAME_PATH = get_node("__INPUTBLOCKER__/MC_Get_Game_Path")
@onready var INPUTBLOCKER_GET_MODS_PATH = get_node("__INPUTBLOCKER__/MC_Get_USER_MODS_Path")

@onready var INPUTBLOCKER_WARNING = get_node("__INPUTBLOCKER__/CC_WARNING")
@onready var INPUTBLOCKER_WARNING_LBL = get_node("__INPUTBLOCKER__/CC_WARNING/NULL/LBL_WARNING_TEXT")
@onready var INPUTBLOCKER_WARNING_BTN = get_node("__INPUTBLOCKER__/CC_WARNING/NULL/BTN_WARNING")
@onready var INPUTBLOCKER_CUSTOM_WARNING_MODS_IN_MODS = get_node("__INPUTBLOCKER__/CC_CUSTOM_WARNING_MODS_IN_~MODS")
@onready var INPUTBLOCKER_CWMIM_BTN_IMPORT = get_node("__INPUTBLOCKER__/CC_CUSTOM_WARNING_MODS_IN_~MODS/NULL/MarginContainer/HBoxContainer/BTN_IMPORT")
@onready var INPUTBLOCKER_CWMIM_BTN_IGNORE = get_node("__INPUTBLOCKER__/CC_CUSTOM_WARNING_MODS_IN_~MODS/NULL/MarginContainer/HBoxContainer/BTN_IGNORE")
@onready var INPUTBLOCKER_CWMIM_ANIM_PLAYER = get_node("__INPUTBLOCKER__/CC_CUSTOM_WARNING_MODS_IN_~MODS/WARNING_AnimationPlayer")

@onready var MODS_ITEM_PREFAB = "res://Scenes/PREFABS/Mods_Item_Prefab.tscn"
@onready var MODS_ITEM_CONTROLLER_PREFAB = "res://Scenes/PREFABS/MODS_TOP_CONTROLLER.tscn"
@onready var MOD_LIST = get_node("VBC MAIN/HBoxContainer/PNL_MODS_LIST/MC_MODS_LIST/SC_MODS_LIST/VBC_MODS_LIST")
@onready var PRESET_LIST = get_node("VBC MAIN/HBoxContainer/Panel/MarginContainer/ScrollContainer/VBoxContainer")
@onready var PRESET_ITEM = "res://Scenes/PREFABS/Preset_Prefab.tscn"



@onready var BTN_TAGS = get_node("VBC MAIN/PC_Header/MarginContainer/HBoxContainer/BTN_TAGS")
@onready var AD_TAGS = get_node("__INPUTBLOCKER__/AD_Tags")
@onready var AD_TAGS_LIST = get_node("__INPUTBLOCKER__/AD_Tags/MarginContainer/ScrollContainer/VBoxContainer")
@onready var VIEW_TAGS_PREFAB = "res://Scenes/PREFABS/View_Tags_Prefab.tscn"
@onready var CREATE_TAGS_PREFAB = "res://Scenes/PREFABS/Create_Tags_Prefab.tscn"

@onready var BTN_CHARA = get_node("VBC MAIN/PC_Header/MarginContainer/HBoxContainer/BTN_CHARACTERS")
@onready var AD_CHARA = get_node("__INPUTBLOCKER__/AD_Chara")
@onready var AD_CHARA_LIST = get_node("__INPUTBLOCKER__/AD_Chara/MarginContainer/ScrollContainer/VBoxContainer")
@onready var VIEW_CHARA_PREFAB = "res://Scenes/PREFABS/View_Chara_Prefab.tscn"
@onready var CREATE_CHARA_PREFAB = "res://Scenes/PREFABS/Create_Chara_Prefab.tscn"


@onready var BTN_FILTER = get_node("VBC MAIN/PC_Header/MarginContainer/HBoxContainer/BTN_FILTER_MODS")
@onready var AD_FILTER = get_node("__INPUTBLOCKER__/AD_FILTER")
@onready var AD_FILTER_TAGS_LIST = get_node("__INPUTBLOCKER__/AD_FILTER/MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer/PC_TAGS/VBoxContainer3/Tag_List")
@onready var AD_FILTER_CHARAS_LIST = get_node("__INPUTBLOCKER__/AD_FILTER/MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer/PC_CHARA/VBoxContainer3/Chara_List")
@onready var AD_FILTER_BTN_RESET_FILTERS = get_node("__INPUTBLOCKER__/AD_FILTER/MarginContainer/ScrollContainer/VBoxContainer/BTN_RESET_FILTERS")

@onready var BTN_APPLY = get_node("VBC MAIN/PC_Header/MarginContainer/HBoxContainer/BTN_APPLY_MODS")

@onready var BTN_SETTINGS = get_node("VBC MAIN/PC_Header/MarginContainer/HBoxContainer/BTN_SETTINGS")
@onready var SETTINGS = get_node("SETTINGS")
@onready var BTN_SETTINGS_RETURN = get_node("SETTINGS/MarginContainer/Panel/VBoxContainer/BTN_RETURN")
@onready var BTN_SETTINGS_DUMP = get_node("SETTINGS/MarginContainer/Panel/VBoxContainer/MarginContainer/VBoxContainer/BTN_DUMP")
@onready var BTN_SETTINGS_CLONE_DUMP = get_node("SETTINGS/MarginContainer/Panel/VBoxContainer/MarginContainer/VBoxContainer/BTN_DUMP_UNDEST")
@onready var BTN_SETTINGS_HARD_RESET = get_node("SETTINGS/MarginContainer/Panel/VBoxContainer/MarginContainer/VBoxContainer/BTN_HARDRESET")


@onready var CUSTOM_CHECKBOX = "res://Scenes/PREFABS/Simple_Checkbox.tscn"


@onready var ANIM_TRANS = get_node("ANIM_TRANS")
@onready var FILEDIALOG = get_node("Popups/FileDialog")

@onready var TE_IMPORT = get_node("SETTINGS/MarginContainer/Panel/VBoxContainer/MarginContainer/VBoxContainer/Panel/TextEdit")


var INPUTBLOCKER_OPEN_TOGGLE = false

var CWMIM_BTN_REPONSE = ""

var FILE_DIALOG_DIR_SELECTED = ""
var CONFIG_FILE_TEMPLATE = {
	"PRESETS": [],
	"TAGS": [], # 2D array ["name","Color"]
	"CHARACTERS": []
}
var DATA_FILE_TEMPLATE = {
	"ORIGINAL_NAME": "",
	"DISPLAY_NAME": "",
	"TAGS": [],
	"CHARACTER": "",
	"INDEX": 0,
	"PINNED": false,
}
# Called when the node enters the scene tree for the first time.
var RENAME_QUEUE = []
func _ready():
	INPUTBLOCKER_CWMIM_BTN_IMPORT.pressed.connect(CWMIN_BTN_IMPORT.bind())
	INPUTBLOCKER_CWMIM_BTN_IGNORE.pressed.connect(CWMIN_BTN_IGNORE.bind())
	
	BTN_TAGS.pressed.connect(BTN_TAGS_PRESSED.bind())
	AD_TAGS.confirmed.connect(AD_TAGS_CLOSED.bind())
	
	BTN_CHARA.pressed.connect(BTN_CHARA_PRESSED.bind())
	AD_CHARA.confirmed.connect(AD_CHARA_CLOSED.bind())
	
	BTN_FILTER.pressed.connect(BTN_FILTER_PRESSED.bind())
	AD_FILTER.confirmed.connect(AD_FILTER_CLOSED.bind())
	AD_FILTER_BTN_RESET_FILTERS.pressed.connect(BTN_RESET_FILTERS_PRESSED.bind())
	
	BTN_APPLY.pressed.connect(BTN_APPLY_PRESSED.bind())
	
	BTN_SETTINGS.pressed.connect(BTN_SETTINGS_PRESSED.bind())
	BTN_SETTINGS_RETURN.pressed.connect(BTN_SETTINGS_RETURN_PRESSED.bind())
	BTN_SETTINGS_DUMP.pressed.connect(BTN_SETTINGS_DUMP_PRESSED.bind())
	BTN_SETTINGS_CLONE_DUMP.pressed.connect(BTN_SETTINGS_CLONE_DUMP_PRESSED.bind())
	BTN_SETTINGS_HARD_RESET.pressed.connect(BTN_SETTINGS_HARD_RESET_PRESSED.bind())
	
	await Global.LOAD_SAVE()
	await CHECK_SAVED_GAME_PATH_MANAGER()
	await CHECK_MODS_PATH_EXISTS()
	await CHECK_MODS_PATH_QUALITY()
	await CHECK_SAVED_USER_MODS_PATH_MANAGER()
	await SETUP_SAVED_USER_MODS_PATH()
	await CHECK_SAVED_USER_MODS_PATH_QUALITY()
	await Global.SAVE_SAVE()
	await Global.DEFRAGMENT_INDEX_VALUES()
	await POPULATE_MODS([],[])
func CHECK_SAVED_GAME_PATH_MANAGER():
	while true:
		var CanClose = await CHECK_SAVED_GAME_PATH()
		if(CanClose == true): break
		else: CHECK_SAVED_GAME_PATH()
func CHECK_SAVED_GAME_PATH():
	var GAME_PATH_CORRECT = func (PATH):
		if(DirAccess.dir_exists_absolute(PATH + r"\RED") and DirAccess.dir_exists_absolute(PATH + r"\ENGINE")):
			return true
		else:
			return false
	if(Global.SAVE_DATA["GAME_PATH"]): # Checks Dir
		if(GAME_PATH_CORRECT.call(Global.SAVE_DATA["GAME_PATH"]) == false):
			if(INPUTBLOCKER_GET_GAME_PATH.visible == false):
				INPUTBLOCKER.visible = true
				INPUTBLOCKER_GET_GAME_PATH.visible = true
			var DIR_SELECTED = await FILEDIALOG.dir_selected
			if(GAME_PATH_CORRECT.call(DIR_SELECTED) != true):
				Global.SAVE_DATA["GAME_PATH"]
				return false
			else:
				print("Valid Save Path")
			Global.SAVE_DATA["GAME_PATH"] = DIR_SELECTED
			await CHANGE_DISPLAYED_WINDOW([INPUTBLOCKER, INPUTBLOCKER_GET_GAME_PATH], [INPUTBLOCKER, INPUTBLOCKER_GET_MODS_PATH])
			return true
		else:
			return true
	else: # Gets Dir
		if(INPUTBLOCKER_GET_GAME_PATH.visible == false):
			INPUTBLOCKER.visible = true
			INPUTBLOCKER_GET_GAME_PATH.visible = true
		var DIR_SELECTED = await FILEDIALOG.dir_selected
		if(GAME_PATH_CORRECT.call(DIR_SELECTED) != true):
			return false
		else:
			print("Valid Save Path")
			Global.SAVE_DATA["GAME_PATH"] = DIR_SELECTED
			await CHANGE_DISPLAYED_WINDOW([INPUTBLOCKER, INPUTBLOCKER_GET_GAME_PATH], [INPUTBLOCKER, INPUTBLOCKER_GET_MODS_PATH])
			return true
func CHECK_MODS_PATH_EXISTS():
	var RED_MODS_PATH = Global.SAVE_DATA["GAME_PATH"] + r"\RED\Content\Paks\~MODS"
	if(DirAccess.dir_exists_absolute(RED_MODS_PATH)):
		print("~Mods Exists")
	else:
		print("~Mods Doesnt Exist Creating")
		DirAccess.make_dir_absolute(RED_MODS_PATH)
		print('~Mods Created : "' + RED_MODS_PATH + '"')
func CHECK_MODS_PATH_QUALITY():
	# Check is ~MODS/DUMH exists if not add
	var DUMH_MODS_PATH = Global.SAVE_DATA["GAME_PATH"] + r"\RED\Content\Paks\~MODS\DUMH"
	if(DirAccess.dir_exists_absolute(DUMH_MODS_PATH)):
		print(r"~Mods\DUMH Exists")
	else:
		print(r"~Mods\DUMH Doesnt Exist Creating")
		DirAccess.make_dir_absolute(DUMH_MODS_PATH)
		print(r'~Mods\DUMH Created : "' + DUMH_MODS_PATH + '"')
	# Check if ~MODS Contains non DUMH mods and warn
	var DA = DirAccess.open(Global.SAVE_DATA["GAME_PATH"] + r"\RED\Content\Paks\~MODS")
	if(DA.get_files()):
		print("Files found inside ~MODS")
		INPUTBLOCKER_CUSTOM_WARNING_MODS_IN_MODS.visible = true
		INPUTBLOCKER.visible = true
		INPUTBLOCKER_CWMIM_ANIM_PLAYER.play("WARNING_IN")
		await AWAIT_WHILE_CWMIM_REPONSE_NULL()
		print("User chose to " + CWMIM_BTN_REPONSE + " mods")
		INPUTBLOCKER_CUSTOM_WARNING_MODS_IN_MODS.visible = false
		if(CWMIM_BTN_REPONSE == "IMPORT"):
			for FILE in DA.get_files():
				print(FILE)
				var FILEPATH = Global.SAVE_DATA["GAME_PATH"] + r"\RED\Content\Paks\~MODS" + "/" + FILE
				RENAME_QUEUER(FILEPATH,  FILE, false)
	else:
		print("No files found inside ~MODS")
	await CHECK_APPLIED_MODS()
	print("Currently applied mods : "+str(Global.MODS_APPLYED))
func CHECK_APPLIED_MODS():
	Global.MODS_APPLYED = []
	var DA = DirAccess.open(Global.SAVE_DATA["GAME_PATH"] + r"\RED\Content\Paks\~MODS\DUMH")
	for FILE in DA.get_files():
		if(FILE.contains(".pak")):
			Global.MODS_APPLYED.append(FILE.left(FILE.length() - 4))
func AWAIT_WHILE_CWMIM_REPONSE_NULL():
	while CWMIM_BTN_REPONSE == "":
		await get_tree().create_timer(0.1).timeout
func CHECK_SAVED_USER_MODS_PATH_MANAGER():
	while true:
		var CanClose = await CHECK_SAVED_USER_MODS_PATH()
		if(CanClose == true): break
		else: CHECK_SAVED_USER_MODS_PATH()
func CHECK_SAVED_USER_MODS_PATH():# Also checks to make sure it exists
	var CHECK_PATH_CORRECT = func(PATH):
		if(DirAccess.dir_exists_absolute(PATH) and !DirAccess.dir_exists_absolute(PATH + r"\RED") and !DirAccess.dir_exists_absolute(PATH + r"\Engine")):
			return true
		else: return false
		
	if(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"]):
		if(CHECK_PATH_CORRECT.call(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"]) == false):
			Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] = ""
			return false
		else:
			print("Valid Mods Path")
			Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] = Global.SAVE_DATA["USER_MODS_FOLDER_PATH"]
			if(INPUTBLOCKER_GET_MODS_PATH.visible):
				await CHANGE_DISPLAYED_WINDOW([INPUTBLOCKER, INPUTBLOCKER_GET_MODS_PATH], [])
			return true
	else:
		if(!INPUTBLOCKER_GET_MODS_PATH.visible):
			INPUTBLOCKER.visible = true
			INPUTBLOCKER_GET_MODS_PATH.visible = true
		var DIR_SELECTED = await FILEDIALOG.dir_selected
		if(CHECK_PATH_CORRECT.call(DIR_SELECTED) != true):
			return false
		else:
			print("Valid Mods Path")
			Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] = DIR_SELECTED
			await CHANGE_DISPLAYED_WINDOW([INPUTBLOCKER, INPUTBLOCKER_GET_MODS_PATH], [])
			return true
func SETUP_SAVED_USER_MODS_PATH():
	var DA = DirAccess.open(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"])
	if(!DA.file_exists(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/CONFIG.json")):
		var CONFIG_FILE = FileAccess.open(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/CONFIG.json",  FileAccess.WRITE)
		var JSON_STRING = JSON.stringify(CONFIG_FILE_TEMPLATE)
		CONFIG_FILE.store_line(JSON_STRING)
	if(!DA.file_exists(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/place mods here.txt")):
		var CONFIG_FILE = FileAccess.open(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/place mods here.txt",  FileAccess.WRITE)
		var JSON_STRING = JSON.stringify(CONFIG_FILE_TEMPLATE)
		CONFIG_FILE.store_string('Add your .pak and .sig files into this folder to add new mods.')
func CHECK_SAVED_USER_MODS_PATH_QUALITY():
# Loop Through Files
# If it finds .pak or .sig
# Check for companion and Folder
	if(RENAME_QUEUE):
		await RENAME_QUEUER("","", true)
	var DA = DirAccess.open(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"])
	var FILES_IN_PATH = DA.get_files()
	print("FOUND ", FILES_IN_PATH)
	for FILE in FILES_IN_PATH:
		if(!FILE == "CONFIG.json" and !FILE == "README.txt"):
			print("Searching File : " + FILE)
			if(FILE.contains(".pak")):
				if(DA.file_exists(FILE.left(FILE.length() - 4) + ".sig")):
					print("Found Companion: " + FILE.left(FILE.length() - 4) + ".sig")
					var NEW_PATH =  Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/" +FILE.left(FILE.length() - 4)
					print("Creating Folder: " + NEW_PATH)
					DirAccess.make_dir_absolute(NEW_PATH)
					print("Renameing File : " + Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/" +FILE)
					DirAccess.rename_absolute(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/" +FILE, NEW_PATH + "/" +FILE)
					print("Renamed File to: " + NEW_PATH + "/" +FILE)
					
					print("Renameing File : " + Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/" +FILE.left(FILE.length() - 4) + ".sig")
					DirAccess.rename_absolute(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/" +FILE.left(FILE.length() - 4) + ".sig", NEW_PATH + "/" +FILE.left(FILE.length() - 4) + ".sig")
					print("Renamed File to: " + NEW_PATH + "/" +FILE.left(FILE.length() - 4) + ".sig")
					var Data_FILE = FileAccess.open(NEW_PATH + "/DATA.json",  FileAccess.WRITE)
					var TEMP_DATA_FILE_TEMPLATE = DATA_FILE_TEMPLATE
					TEMP_DATA_FILE_TEMPLATE["DISPLAY_NAME"] = FILE.left(FILE.length() - 4)
					TEMP_DATA_FILE_TEMPLATE["ORIGINAL_NAME"] = FILE.left(FILE.length() - 4)
					TEMP_DATA_FILE_TEMPLATE["INDEX"] = Global.SAVE_DATA["NEXT_INDEX_SLOT"]
					Global.SAVE_DATA["NEXT_INDEX_SLOT"] += 1
					var JSON_STRING = JSON.stringify(TEMP_DATA_FILE_TEMPLATE)
					Data_FILE.store_line(JSON_STRING)
					print("Added DATA.json:")
				else:
					print("Lacks Companion: " + FILE.left(FILE.length() - 4) + ".sig")
					print("Skipping       :")
			if(FILE.contains(".sig")):
				if(!DA.file_exists(FILE)):
					print("File Is Missing: " + FILE)
				else:
					print("Lacks Companion: " + FILE.left(FILE.length() - 4) + ".pak")
					print("Skipping       :")
	for DIR in DA.get_directories():
		if(!DA.file_exists(DIR + "/" + "DATA.json")):
			var Data_FILE = FileAccess.open(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/" +DIR + "/DATA.json",  FileAccess.WRITE)
			var TEMP_DATA_FILE_TEMPLATE = DATA_FILE_TEMPLATE
			TEMP_DATA_FILE_TEMPLATE["DISPLAY_NAME"] = DIR
			TEMP_DATA_FILE_TEMPLATE["ORIGINAL_NAME"] = DIR
			TEMP_DATA_FILE_TEMPLATE["INDEX"] = Global.SAVE_DATA["NEXT_INDEX_SLOT"]
			Global.SAVE_DATA["NEXT_INDEX_SLOT"] += 1
			var JSON_STRING = JSON.stringify(TEMP_DATA_FILE_TEMPLATE)
			Data_FILE.store_line(JSON_STRING)
			print("Added DATA.json:")
func POPULATE_MODS(TAGS, CHARACTERS):
	Global.POPULATE = false
	var DA = DirAccess.open(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"])
	for N in MOD_LIST.get_children():
		MOD_LIST.remove_child(N)
		N.queue_free()
		
	var FILE_DATA = FileAccess.open(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/CONFIG.json",  FileAccess.READ);
	var JSON_STRING = FILE_DATA.get_as_text()
	var FILE_AS_DICT = JSON.parse_string(JSON_STRING)

	for N in PRESET_LIST.get_children():
		PRESET_LIST.remove_child(N)
		N.queue_free()
		
	for PRESET in FILE_AS_DICT["PRESETS"]:
		var ITEM = load(PRESET_ITEM).instantiate()
		ITEM.NAME = PRESET[0]
		PRESET_LIST.add_child(ITEM)
		
	var ITEM = load(MODS_ITEM_CONTROLLER_PREFAB).instantiate()
	MOD_LIST.add_child(ITEM)
	
	for DIR in await Global.LIST_MODS_BY_INDEX():
		var FULL_DIR_PATH = Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/" + DIR[0]
		FILE_DATA = FileAccess.open(FULL_DIR_PATH + "/DATA.json" ,FileAccess.READ);
		JSON_STRING = FILE_DATA.get_as_text()
		FILE_AS_DICT = JSON.parse_string(JSON_STRING)
		if(FILE_AS_DICT["PINNED"]):
			var CORRECT_TAGS = false
			var CORRECT_CHARS = false
			if(TAGS):
				for MOD_TAG in FILE_AS_DICT["TAGS"]:
					for APPLYED_TAG in TAGS:
						if(APPLYED_TAG == MOD_TAG):
							CORRECT_TAGS = true
			else:
				CORRECT_TAGS = true
			if(CHARACTERS):
				for MOD_CHAR in FILE_AS_DICT["CHARACTER"]:
					for APPLYED_CHAR in CHARACTERS:
						if(APPLYED_CHAR == MOD_CHAR):
							CORRECT_CHARS = true
			else:
				CORRECT_CHARS = true
			if(CORRECT_TAGS and CORRECT_CHARS):
				CREATE_MOD_PREFAB(FILE_AS_DICT)
	for DIR in await Global.LIST_MODS_BY_INDEX():
		var FULL_DIR_PATH = Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/" + DIR[0]
		FILE_DATA = FileAccess.open(FULL_DIR_PATH + "/DATA.json" ,FileAccess.READ);
		JSON_STRING = FILE_DATA.get_as_text()
		FILE_AS_DICT = JSON.parse_string(JSON_STRING)
		if(!FILE_AS_DICT["PINNED"]):
			var CORRECT_TAGS = false
			var CORRECT_CHARS = false
			if(TAGS):
				for MOD_TAG in FILE_AS_DICT["TAGS"]:
					for APPLYED_TAG in TAGS:
						if(APPLYED_TAG == MOD_TAG):
							CORRECT_TAGS = true
			else:
				CORRECT_TAGS = true
			if(CHARACTERS):
				for APPLYED_CHAR in CHARACTERS:
					if(APPLYED_CHAR == FILE_AS_DICT["CHARACTER"]):
						CORRECT_CHARS = true
			else:
				CORRECT_CHARS = true
			if(CORRECT_TAGS and CORRECT_CHARS):
				CREATE_MOD_PREFAB(FILE_AS_DICT)


func CREATE_MOD_PREFAB(SETTINGS):
	var ITEM = load(MODS_ITEM_PREFAB).instantiate()
	ITEM.SETTINGS = SETTINGS
	MOD_LIST.add_child(ITEM)
		
func _process(delta: float) -> void:
	#print(Global.MODS_APPLYED)
	#print(Global.MODS_TO_APPLY)
	#print(Global.MODS_TO_UNAPPLY)
	if(INPUTBLOCKER.visible == true):
		Global.CAN_REFRESH = false
	else:
		Global.CAN_REFRESH = true
		
		
	if(Global.REFRESH_WINDOW):
		_ready()
		Global.REFRESH_WINDOW = false
	
	if(Global.POPULATE):
		POPULATE_MODS(Global.POPULATE_TAGS, Global.POPULATE_CHARAS)
	if(Global.SETTINGS_WINDOW_OPEN):
		INPUTBLOCKER_OPEN_TOGGLE = true
	if(Global.SETTINGS_WINDOW_OPEN):
		INPUTBLOCKER.visible = true
	if(!Global.SETTINGS_WINDOW_OPEN and INPUTBLOCKER_OPEN_TOGGLE):
		INPUTBLOCKER.visible = false
		INPUTBLOCKER_OPEN_TOGGLE = false
	
func RENAME_QUEUER(FROM, TO, RUN):
	if(!RUN):
		RENAME_QUEUE.append([FROM, TO])
	if(RUN):
		print("RENAME_QUEUER is running")
		for ITEM in RENAME_QUEUE:
			DirAccess.rename_absolute(ITEM[0], Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/" + ITEM[1])
func DISPLAY_WARNING(MESSAGE):
	INPUTBLOCKER_WARNING.visible = true
	INPUTBLOCKER.visible = true
	INPUTBLOCKER_WARNING_LBL.set_text(MESSAGE)
	await INPUTBLOCKER_WARNING_BTN.pressed
	INPUTBLOCKER_WARNING.visible = false
	INPUTBLOCKER.visible = false
func CHANGE_DISPLAYED_WINDOW(OLD_WINDOWS, NEW_WINDOWS):
	print("--CHANGING WINDOW FROM--")
	print(OLD_WINDOWS)
	print("--CHANGING WINDOW TO--")
	print(NEW_WINDOWS)
	ANIM_TRANS.play("ANIM_IN")
	await ANIM_TRANS.animation_finished
	for WINDOW in OLD_WINDOWS:
		WINDOW.visible = false
	for WINDOW in NEW_WINDOWS:
		WINDOW.visible = true
	ANIM_TRANS.play("ANIM_OUT")
	await ANIM_TRANS.animation_finished
func ON_BTN_OPEN_FILE_MANAGER_PRESSED(): # Makes the filedialog visible
	FILEDIALOG.visible = true



func CWMIN_BTN_IMPORT():
	CWMIM_BTN_REPONSE = "IMPORT"
func CWMIN_BTN_IGNORE():
	CWMIM_BTN_REPONSE = "IGNORE"


func BTN_TAGS_PRESSED():
	AD_TAGS.visible = true
	INPUTBLOCKER.visible = true
	for N in AD_TAGS_LIST.get_children():
		AD_TAGS_LIST.remove_child(N)
		N.queue_free()
	var FILE_DATA = FileAccess.open(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/CONFIG.json",  FileAccess.READ);
	var JSON_STRING = FILE_DATA.get_as_text()
	var FILE_AS_DICT = JSON.parse_string(JSON_STRING)
	var TAGS = FILE_AS_DICT["TAGS"]
	
	var ITEM = load(CREATE_TAGS_PREFAB).instantiate()
	AD_TAGS_LIST.add_child(ITEM)
	for X in TAGS:
		var ITEM_TAG = load(VIEW_TAGS_PREFAB).instantiate()
		ITEM_TAG.TAG_NAME = X[0]
		AD_TAGS_LIST.add_child(ITEM_TAG)
func AD_TAGS_CLOSED():
	INPUTBLOCKER.visible = false
	for N in AD_TAGS_LIST.get_children():
		AD_TAGS_LIST.remove_child(N)
		N.queue_free()


func BTN_CHARA_PRESSED():
	AD_CHARA.visible = true
	INPUTBLOCKER.visible = true
	for N in AD_CHARA_LIST.get_children():
		AD_CHARA_LIST.remove_child(N)
		N.queue_free()
	var FILE_DATA = FileAccess.open(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/CONFIG.json",  FileAccess.READ);
	var JSON_STRING = FILE_DATA.get_as_text()
	var FILE_AS_DICT = JSON.parse_string(JSON_STRING)
	var CHARA = FILE_AS_DICT["CHARACTERS"]
	
	var ITEM = load(CREATE_CHARA_PREFAB).instantiate()
	AD_CHARA_LIST.add_child(ITEM)
	for X in CHARA:
		var ITEM_CHARA = load(VIEW_CHARA_PREFAB).instantiate()
		ITEM_CHARA.CHARA_NAME = X
		AD_CHARA_LIST.add_child(ITEM_CHARA)
func AD_CHARA_CLOSED():
	INPUTBLOCKER.visible = false
	for N in AD_CHARA_LIST.get_children():
		AD_CHARA_LIST.remove_child(N)
		N.queue_free()


func BTN_FILTER_PRESSED():
	AD_FILTER.visible = true
	INPUTBLOCKER.visible = true
	for N in AD_FILTER_TAGS_LIST.get_children():
		AD_FILTER_TAGS_LIST.remove_child(N)
		N.queue_free()
	for N in AD_FILTER_CHARAS_LIST.get_children():
		AD_FILTER_CHARAS_LIST.remove_child(N)
		N.queue_free()
	var FILE_DATA = FileAccess.open(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/CONFIG.json", FileAccess.READ);
	var JSON_STRING = FILE_DATA.get_as_text()
	var FILE_AS_DICT = JSON.parse_string(JSON_STRING)
	var TAGS = FILE_AS_DICT["TAGS"]
	var CHARAS = FILE_AS_DICT["CHARACTERS"]
	for TAG in TAGS:
		var ITEM = load(CUSTOM_CHECKBOX).instantiate()
		ITEM.set_text(TAG[0])
		for X in Global.POPULATE_TAGS:
			if(TAG[0] == X):
				ITEM.set_pressed(true)
		AD_FILTER_TAGS_LIST.add_child(ITEM)
	for CHARA in CHARAS:
		var ITEM = load(CUSTOM_CHECKBOX).instantiate()
		ITEM.set_text(CHARA)
		for X in Global.POPULATE_CHARAS:
			if(CHARA == X):
				ITEM.set_pressed(true)
		AD_FILTER_CHARAS_LIST.add_child(ITEM)
func AD_FILTER_CLOSED():
	INPUTBLOCKER.visible = false
	Global.POPULATE_TAGS = []
	Global.POPULATE_CHARAS = []
	for TAG in AD_FILTER_TAGS_LIST.get_children():
		if(TAG.is_pressed()):
			Global.POPULATE_TAGS.append(TAG.get_text())
	for CHARA in AD_FILTER_CHARAS_LIST.get_children():
		if(CHARA.is_pressed()):
			Global.POPULATE_CHARAS.append(CHARA.get_text())
	Global.POPULATE = true

func BTN_RESET_FILTERS_PRESSED():
	INPUTBLOCKER.visible = false
	AD_FILTER.visible = false
	Global.POPULATE_TAGS = []
	Global.POPULATE_CHARAS = []
	Global.POPULATE = true

func BTN_APPLY_PRESSED():
	await CHECK_APPLIED_MODS()
	for NAME in Global.MODS_TO_APPLY:
		DirAccess.copy_absolute(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"]+"/"+NAME+"/"+NAME+".pak", Global.SAVE_DATA["GAME_PATH"] + r"\RED\Content\Paks\~MODS\DUMH"+"/"+NAME+".pak")
		DirAccess.copy_absolute(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"]+"/"+NAME+"/"+NAME+".sig", Global.SAVE_DATA["GAME_PATH"] + r"\RED\Content\Paks\~MODS\DUMH"+"/"+NAME+".sig")
		print("Applyed mod " + NAME)
	for NAME in Global.MODS_TO_UNAPPLY:
		DirAccess.remove_absolute(Global.SAVE_DATA["GAME_PATH"] + r"\RED\Content\Paks\~MODS\DUMH"+"/"+NAME+".pak")
		DirAccess.remove_absolute(Global.SAVE_DATA["GAME_PATH"] + r"\RED\Content\Paks\~MODS\DUMH"+"/"+NAME+".sig")
		print("Removed mod " + NAME)
	Global.MODS_TO_APPLY = []
	Global.MODS_TO_UNAPPLY = []
	await CHECK_APPLIED_MODS()
	Global.POPULATE = true

func BTN_SETTINGS_PRESSED():
	CHANGE_DISPLAYED_WINDOW([],[SETTINGS])

func BTN_SETTINGS_RETURN_PRESSED():
	CHANGE_DISPLAYED_WINDOW([SETTINGS],[])

func BTN_SETTINGS_DUMP_PRESSED():
	var LIST = await Global.LIST_MODS_BY_INDEX()
	Global.MODS_TO_APPLY = []
	Global.MODS_TO_UNAPPLY = []
	Global.MODS_APPLYED = []
	for NAME in LIST:
		await DirAccess.copy_absolute(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"]+"/"+NAME[0]+"/"+NAME[0]+".pak", Global.SAVE_DATA["GAME_PATH"] + r"\RED\Content\Paks\~MODS\DUMH"+"/"+NAME[0]+".pak")
		await DirAccess.copy_absolute(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"]+"/"+NAME[0]+"/"+NAME[0]+".sig", Global.SAVE_DATA["GAME_PATH"] + r"\RED\Content\Paks\~MODS\DUMH"+"/"+NAME[0]+".sig")
		await DirAccess.remove_absolute(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"]+"/"+NAME[0]+"/"+NAME[0]+".sig")
		await DirAccess.remove_absolute(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"]+"/"+NAME[0]+"/"+NAME[0]+".pak")
		await DirAccess.remove_absolute(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"]+"/"+NAME[0]+"/DATA.json")
		await DirAccess.remove_absolute(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"]+"/"+NAME[0])
		print("Moved to ~MODS "+ NAME[0])
	await CHECK_APPLIED_MODS()
	Global.POPULATE = true
	
func BTN_SETTINGS_CLONE_DUMP_PRESSED():
	var LIST = await Global.LIST_MODS_BY_INDEX()
	Global.MODS_TO_APPLY = []
	Global.MODS_TO_UNAPPLY = []
	Global.MODS_APPLYED = []
	for NAME in LIST:
		await DirAccess.copy_absolute(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"]+"/"+NAME[0]+"/"+NAME[0]+".pak", Global.SAVE_DATA["GAME_PATH"] + r"\RED\Content\Paks\~MODS\DUMH"+"/"+NAME[0]+".pak")
		await DirAccess.copy_absolute(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"]+"/"+NAME[0]+"/"+NAME[0]+".sig", Global.SAVE_DATA["GAME_PATH"] + r"\RED\Content\Paks\~MODS\DUMH"+"/"+NAME[0]+".sig")
		print("Moved to ~MODS "+ NAME[0])
	await CHECK_APPLIED_MODS()
	Global.POPULATE = true
	
func BTN_SETTINGS_HARD_RESET_PRESSED():
	Global.HARD_RESET()
	get_tree().quit()
	
	
	
var MODSLIST_PATHS_IMPORT = []
var MODSLIST_PATHS_DEEPER = []
func BTN_IMPORT_PRESSED() -> void:
	ON_BTN_OPEN_FILE_MANAGER_PRESSED
	var FILEPATH = TE_IMPORT.get_text()
	if(FILEPATH):
		if(DirAccess.dir_exists_absolute(FILEPATH)):
			var DA = DirAccess.open(FILEPATH)
			var DIRS = DA.get_directories()	
			for DIR in DIRS:
				FIND(FILEPATH +"/"+ DIR)
			
			for DIR in MODSLIST_PATHS_DEEPER:
				FIND(DIR)
			for ITEM in MODSLIST_PATHS_DEEPER:
				MODSLIST_PATHS_IMPORT.append(ITEM)
			for X in MODSLIST_PATHS_IMPORT:
				print("Found : " + X)
			print(str(len(MODSLIST_PATHS_IMPORT)) + " Folders found")
			IMPORT()
func FIND(PATH):
	MODSLIST_PATHS_DEEPER.erase(PATH)
	var SUBDIRS =  DirAccess.get_directories_at(PATH)
	for SUBDIR in SUBDIRS:
		MODSLIST_PATHS_DEEPER.append(PATH + "/" + SUBDIR)
	MODSLIST_PATHS_IMPORT.append(PATH)
func IMPORT():
	for ITEM in MODSLIST_PATHS_IMPORT:
		var FILES =  DirAccess.get_files_at(ITEM)
		for FILE in FILES:
			if(FILE.contains(".pak")):
				DirAccess.copy_absolute(ITEM + "/" + FILE, Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/" + FILE)
			if(FILE.contains(".sig")):
				DirAccess.copy_absolute(ITEM + "/" + FILE, Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/" + FILE)
