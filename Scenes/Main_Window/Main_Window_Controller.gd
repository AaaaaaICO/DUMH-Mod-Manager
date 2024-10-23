extends Control

signal LATEST_RELEASE_FOUND(LATEST_RELEASE)
signal CONFIRMED_DOWNLOAD_INSTRUCTIONS(ACCEPTED)

signal WAS_DOWNLOAD_SUCCESSFUL(SUCCESSFUL)

@onready var MODS_ITEM_PREFAB = "res://Scenes/PREFABS/Mods_Item_Prefab.tscn"
@onready var MODS_ITEM_CONTROLLER_PREFAB = "res://Scenes/PREFABS/MODS_TOP_CONTROLLER.tscn"
@onready var PRESET_ITEM = "res://Scenes/PREFABS/Preset_Prefab.tscn"
@onready var VIEW_TAGS_PREFAB = "res://Scenes/PREFABS/View_Tags_Prefab.tscn"
@onready var CREATE_TAGS_PREFAB = "res://Scenes/PREFABS/Create_Tags_Prefab.tscn"
@onready var VIEW_CHARA_PREFAB = "res://Scenes/PREFABS/View_Chara_Prefab.tscn"
@onready var CREATE_CHARA_PREFAB = "res://Scenes/PREFABS/Create_Chara_Prefab.tscn"
@onready var CUSTOM_CHECKBOX = "res://Scenes/PREFABS/Simple_Checkbox.tscn"

@onready var SAVE_SLOTS_MAKER_PREFAB = "res://Scenes/PREFABS/SAVE_SLOT_MAKER.tscn"

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
	var EXE_PATH = OS.get_executable_path()
	var FOLDER_PATH = EXE_PATH.split("/DUMH (Mod Helper).exe")[0]
	var NEW_EXE_PATH = FOLDER_PATH + "/DUMH.Mod.Helper.exe"
	var NEW_OLD_PATH = FOLDER_PATH + "/DELETE_DUMH_BACKDATED.exe"
	
	if(FileAccess.file_exists(NEW_OLD_PATH)):
		DirAccess.remove_absolute(NEW_OLD_PATH)
	
	%BTN_UPDATE.pressed.connect(BTN_UPDATE_PRESSED.bind()) 
	%BTN_DELINE_UPDATE.pressed.connect(BTN_DECLINE_UPDATE_PRESSED.bind()) 
	
	%BTN_WARNING_IMPORT.pressed.connect(CWMIN_BTN_IMPORT.bind())
	%BTN_WARNING_IGNORE.pressed.connect(CWMIN_BTN_IGNORE.bind())
	 
	%BTN_TAGS.pressed.connect(BTN_TAGS_PRESSED.bind())
	%AD_Tags.confirmed.connect(AD_TAGS_CLOSED.bind())
	
	%BTN_CHARACTERS.pressed.connect(BTN_CHARA_PRESSED.bind())
	%AD_CHARA.confirmed.connect(AD_CHARA_CLOSED.bind())
	
	%BTN_FILTER_MODS.pressed.connect(BTN_FILTER_PRESSED.bind())
	%AD_FILTER.confirmed.connect(AD_FILTER_CLOSED.bind())
	%BTN_RESET_FILTERS.pressed.connect(BTN_RESET_FILTERS_PRESSED.bind())
	
	%BTN_APPLY_MODS.pressed.connect(BTN_APPLY_PRESSED.bind())
	%BTN_SAVE_SLOTS.pressed.connect(BTN_SAVE_SLOTS_PRESSED.bind())
	%SAVE_SLOTS_MANAGER.confirmed.connect(SAVE_SLOTS_CLOSED.bind())
	
	%BTN_SETTINGS.pressed.connect(BTN_SETTINGS_PRESSED.bind())
	%BTN_RETURN.pressed.connect(BTN_SETTINGS_RETURN_PRESSED.bind())
	%BTN_Import.pressed.connect(BTN_IMPORT_PRESSED.bind())
	%BTN_DUMP.pressed.connect(BTN_SETTINGS_DUMP_PRESSED.bind())
	%BTN_DUMP_UNDEST.pressed.connect(BTN_SETTINGS_CLONE_DUMP_PRESSED.bind())
	%BTN_HARDRESET.pressed.connect(BTN_SETTINGS_HARD_RESET_PRESSED.bind())
	
	%TAG.text = "Made by AaaaaaICO
	Github -> https://github.com/AaaaaaICO
	" + Global.CURRENT_VER
	
	await Global.LOAD_SAVE()
	
	
	%HTTP_REQUEST.request_completed.connect(GET_LATEST_RELEASE.bind())
	$HTTP_REQUEST.request("https://github.com/AaaaaaICO/DUMH-Mod-Manager/tags")
	var LATEST_RELEASE_LINK = await LATEST_RELEASE_FOUND
	var LINK_SPLITS = LATEST_RELEASE_LINK.split("/")
	var RELEASE_VER = LINK_SPLITS[5]
	if(RELEASE_VER != Global.CURRENT_VER):
		%__INPUTBLOCKER__.show()
		%CC_UPDATE_AVAILABLE.show()
		var DOWNLOAD_ADRESS = ""
		var PATH = ""
		if(Global.USER_SYSTEM == "Windows"):
			DOWNLOAD_ADRESS = "https://github.com/AaaaaaICO/DUMH-Mod-Manager/releases/download/"+ RELEASE_VER +"/DUMH.Mod.Helper.exe"
			PATH = "DUMH.Mod.Helper.exe"
		if(Global.USER_SYSTEM == "Linux"):
			DOWNLOAD_ADRESS = "https://github.com/AaaaaaICO/DUMH-Mod-Manager/releases/download/"+ RELEASE_VER +"/DUMH.Mod.Helper.x86_64"
			PATH = "DUMH.Mod.Helper.x86_64"
		%LBL_UPDATE_VER.text = Global.CURRENT_VER + " -> " + RELEASE_VER
		var CONFIRMED_DOWNLOAD_INSTRUCTIONS_RESULTS = await CONFIRMED_DOWNLOAD_INSTRUCTIONS
		if(CONFIRMED_DOWNLOAD_INSTRUCTIONS_RESULTS):
			%HTTP_DOWNLOADER.request_completed.connect(DOWNLOAD.bind())
			%HTTP_DOWNLOADER.set_download_file(PATH)
			var REQUEST = %HTTP_DOWNLOADER.request(DOWNLOAD_ADRESS)
			var SUCCESSFUL = await WAS_DOWNLOAD_SUCCESSFUL
			if(SUCCESSFUL):
				print("DOWNLOAD SUCCESSFUL!!!")
				print("Manipulating exe names")
				DirAccess.rename_absolute(EXE_PATH, NEW_OLD_PATH)
				DirAccess.rename_absolute(NEW_EXE_PATH, EXE_PATH)
				#DirAccess.remove_absolute(NEW_OLD_PATH)
				get_tree().quit()
			else:
				print("DOWNLOAD FAILED!!!")


	if(!Global.SAVE_DATA["SAVE_SLOTS"].is_empty()):
		if(!len(Global.SAVE_DATA["SAVE_SLOTS"]) == 1):	
			var SAVE_SLOTS_MAKER = load(SAVE_SLOTS_MAKER_PREFAB).instantiate()
			%SAVE_SLOTS_MANAGER_VBOX.add_child(SAVE_SLOTS_MAKER)
			%SAVE_SLOTS_MANAGER.show()
			%__INPUTBLOCKER__.show()
	
	Start()

func GET_LATEST_RELEASE(_result, _response_code, _headers, _body):
	var parser: XMLParser = XMLParser.new()
	parser.open_buffer(_body)
	while parser.read() != ERR_FILE_EOF:
		if(parser.has_attribute("href")):
			if(parser.get_attribute_count() >= 2):
				if(parser.get_attribute_value(1).contains("/AaaaaaICO/DUMH-Mod-Manager/releases/tag")):
					LATEST_RELEASE_FOUND.emit(parser.get_attribute_value(1))
		
		
func DOWNLOAD(result, _response_code, _headers, _body):
	if result != OK:
		push_error("Download Failed")
		WAS_DOWNLOAD_SUCCESSFUL.emit(false)
	else:
		WAS_DOWNLOAD_SUCCESSFUL.emit(true)
	
	
func Start():
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
		if(DirAccess.dir_exists_absolute(PATH + r"/RED") and (DirAccess.dir_exists_absolute(PATH + r"/ENGINE") or DirAccess.dir_exists_absolute(PATH + r"/Engine"))):
			return true
		else:
			return false
	if(Global.SAVE_DATA["GAME_PATH"]): # Checks Dir
		if(GAME_PATH_CORRECT.call(Global.SAVE_DATA["GAME_PATH"]) == false):
			if(%MC_Get_Game_Path.visible == false):
				%__INPUTBLOCKER__.visible = true
				%MC_Get_Game_Path.visible = true
			var DIR_SELECTED = await %FILEDIALOG.dir_selected
			if(GAME_PATH_CORRECT.call(DIR_SELECTED) != true):
				Global.SAVE_DATA["GAME_PATH"]
				return false
			else:
				print("Valid Save Path")
			Global.SAVE_DATA["GAME_PATH"] = DIR_SELECTED
			await CHANGE_DISPLAYED_WINDOW([%__INPUTBLOCKER__, %MC_Get_Game_Path], [%__INPUTBLOCKER__, %MC_Get_USER_MODS_Path])
			return true
		else:
			return true
	else: # Gets Dir
		if(%MC_Get_Game_Path.visible == false):
			%__INPUTBLOCKER__.visible = true
			%MC_Get_Game_Path.visible = true
		var DIR_SELECTED = await %FILEDIALOG.dir_selected
		print(DIR_SELECTED)
		if(GAME_PATH_CORRECT.call(DIR_SELECTED) != true):
			return false
		else:
			Global.SAVE_DATA["GAME_PATH"] = DIR_SELECTED
			await CHANGE_DISPLAYED_WINDOW([%__INPUTBLOCKER__, %MC_Get_Game_Path], [%__INPUTBLOCKER__, %MC_Get_USER_MODS_Path])
			return true
func CHECK_MODS_PATH_EXISTS():
	var RED_MODS_PATH = Global.SAVE_DATA["GAME_PATH"] + r"/RED/Content/Paks/~MODS"
	if(DirAccess.dir_exists_absolute(RED_MODS_PATH)):
		print("~Mods Exists")
	else:
		print("~Mods Doesnt Exist Creating")
		DirAccess.make_dir_absolute(RED_MODS_PATH)
		print('~Mods Created : "' + RED_MODS_PATH + '"')
func CHECK_MODS_PATH_QUALITY():
	# Check is ~MODS/DUMH exists if not add
	var DUMH_MODS_PATH = Global.SAVE_DATA["GAME_PATH"] + r"/RED/Content/Paks/~MODS/DUMH"
	if(DirAccess.dir_exists_absolute(DUMH_MODS_PATH)):
		print(r"~Mods/DUMH Exists")
	else:
		print(r"~Mods/DUMH Doesnt Exist Creating")
		DirAccess.make_dir_absolute(DUMH_MODS_PATH)
		print(r'~Mods/DUMH Created : "' + DUMH_MODS_PATH + '"')
	# Check if ~MODS Contains non DUMH mods and warn
	var DA = DirAccess.open(Global.SAVE_DATA["GAME_PATH"] + r"/RED/Content/Paks/~MODS")
	if(DA.get_files()):
		print("Files found inside ~MODS")
		%CC_CUSTOM_WARNING_MODS_IN_MODS.visible = true
		%__INPUTBLOCKER__.visible = true
		%WARNING_AnimationPlayer.play("WARNING_IN")
		await AWAIT_WHILE_CWMIM_REPONSE_NULL()
		print("User chose to " + CWMIM_BTN_REPONSE + " mods")
		%CC_CUSTOM_WARNING_MODS_IN_MODS.visible = false
		if(CWMIM_BTN_REPONSE == "IMPORT"):
			for FILE in DA.get_files():
				print(FILE)
				var FILEPATH = Global.SAVE_DATA["GAME_PATH"] + r"/RED/Content/Paks/~MODS" + "/" + FILE
				RENAME_QUEUER(FILEPATH,  FILE, false)
	else:
		print("No files found inside ~MODS")
	await CHECK_APPLIED_MODS()
	print("Currently applied mods : "+str(Global.MODS_APPLYED))
func CHECK_APPLIED_MODS():
	Global.MODS_APPLYED = []
	var DA = DirAccess.open(Global.SAVE_DATA["GAME_PATH"] + r"/RED/Content/Paks/~MODS/DUMH")
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
		if(DirAccess.dir_exists_absolute(PATH) and !DirAccess.dir_exists_absolute(PATH + r"/RED") and !DirAccess.dir_exists_absolute(PATH + r"/Engine")):
			return true
		else: return false
		
	if(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"]):
		if(CHECK_PATH_CORRECT.call(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"]) == false):
			Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] = ""
			return false
		else:
			print("Valid Mods Path")
			Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] = Global.SAVE_DATA["USER_MODS_FOLDER_PATH"]
			if(%MC_Get_USER_MODS_Path.visible):
				await CHANGE_DISPLAYED_WINDOW([%__INPUTBLOCKER__, %MC_Get_USER_MODS_Path], [])
			return true
	else:
		if(!%MC_Get_USER_MODS_Path.visible):
			%__INPUTBLOCKER__.visible = true
			%MC_Get_USER_MODS_Path.visible = true
		var DIR_SELECTED = await %FILEDIALOG.dir_selected
		if(CHECK_PATH_CORRECT.call(DIR_SELECTED) != true):
			return false
		else:
			print("Valid Mods Path")
			Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] = DIR_SELECTED
			await CHANGE_DISPLAYED_WINDOW([%__INPUTBLOCKER__, %MC_Get_USER_MODS_Path], [])
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
		if(!FILE == "CONFIG.json" and !FILE == "README.txt" and !FILE == "place mods here.txt"):
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

	for FOLDER in DA.get_directories():
		DA = DirAccess.open(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/" + FOLDER)
		var FILES_IN_FOLDER = DA.get_files()
		for FILE in FILES_IN_FOLDER:
			if(FILE.contains(".pak")):
				if(FILE.left(FILE.length() - 4) != FOLDER):
					print("Renaming folder " + FOLDER + " to " + FILE)
					DirAccess.rename_absolute(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/" + FOLDER, Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/" + FILE.left(FILE.length() - 4))
					

func POPULATE_MODS(TAGS, CHARACTERS):
	Global.POPULATE = false
	var DA = DirAccess.open(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"])
	for N in %VBC_MODS_LIST.get_children():
		%VBC_MODS_LIST.remove_child(N)
		N.queue_free()
		
	var FILE_DATA = FileAccess.open(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/CONFIG.json",  FileAccess.READ);
	var JSON_STRING = FILE_DATA.get_as_text()
	var FILE_AS_DICT = JSON.parse_string(JSON_STRING)

	for N in %PRESET_LIST_CONTAINER.get_children():
		%PRESET_LIST_CONTAINER.remove_child(N)
		N.queue_free()
		
	for PRESET in FILE_AS_DICT["PRESETS"]:
		var ITEM = load(PRESET_ITEM).instantiate()
		ITEM.NAME = PRESET[0]
		%PRESET_LIST_CONTAINER.add_child(ITEM)
		
	var ITEM = load(MODS_ITEM_CONTROLLER_PREFAB).instantiate()
	%VBC_MODS_LIST.add_child(ITEM)
	
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
				for CHAR in CHARACTERS:
					if(CHAR == FILE_AS_DICT["CHARACTER"]):
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
	%VBC_MODS_LIST.add_child(ITEM)
		
func _process(delta: float) -> void:
	if(%__INPUTBLOCKER__.visible == true):
		Global.CAN_REFRESH = false
	else:
		Global.CAN_REFRESH = true
		
		
	if(Global.REFRESH_WINDOW):
		Start()
		Global.REFRESH_WINDOW = false
	
	if(Global.POPULATE):
		POPULATE_MODS(Global.POPULATE_TAGS, Global.POPULATE_CHARAS)
	if(Global.SETTINGS_WINDOW_OPEN):
		INPUTBLOCKER_OPEN_TOGGLE = true
	if(Global.SETTINGS_WINDOW_OPEN):
		%__INPUTBLOCKER__.visible = true
	if(!Global.SETTINGS_WINDOW_OPEN and INPUTBLOCKER_OPEN_TOGGLE):
		%__INPUTBLOCKER__.visible = false
		INPUTBLOCKER_OPEN_TOGGLE = false
	
func RENAME_QUEUER(FROM, TO, RUN):
	if(!RUN):
		RENAME_QUEUE.append([FROM, TO])
	if(RUN):
		print("RENAME_QUEUER is running")
		for ITEM in RENAME_QUEUE:
			DirAccess.rename_absolute(ITEM[0], Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/" + ITEM[1])
func DISPLAY_WARNING(MESSAGE):
	%CC_WARNING.visible = true
	%__INPUTBLOCKER__.visible = true
	%LBL_WARNING_TEXT.set_text(MESSAGE)
	await %BTN_WARNING.pressed
	%CC_WARNING.visible = false
	%__INPUTBLOCKER__.visible = false
func CHANGE_DISPLAYED_WINDOW(OLD_WINDOWS, NEW_WINDOWS):
	print("--CHANGING WINDOW FROM--")
	print(OLD_WINDOWS)
	print("--CHANGING WINDOW TO--")
	print(NEW_WINDOWS)
	%ANIM_TRANS.play("ANIM_IN")
	await %ANIM_TRANS.animation_finished
	for WINDOW in OLD_WINDOWS:
		WINDOW.visible = false
	for WINDOW in NEW_WINDOWS:
		WINDOW.visible = true
	%ANIM_TRANS.play("ANIM_OUT")
	await %ANIM_TRANS.animation_finished
func ON_BTN_OPEN_FILE_MANAGER_PRESSED(): # Makes the filedialog visible
	%FILEDIALOG.visible = true



func CWMIN_BTN_IMPORT():
	CWMIM_BTN_REPONSE = "IMPORT"
func CWMIN_BTN_IGNORE():
	CWMIM_BTN_REPONSE = "IGNORE"


func BTN_TAGS_PRESSED():
	%AD_Tags.visible = true
	%__INPUTBLOCKER__.visible = true
	for N in %TAGS_CONTAINER.get_children():
		%TAGS_CONTAINER.remove_child(N)
		N.queue_free()
	var FILE_DATA = FileAccess.open(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/CONFIG.json",  FileAccess.READ);
	var JSON_STRING = FILE_DATA.get_as_text()
	var FILE_AS_DICT = JSON.parse_string(JSON_STRING)
	var TAGS = FILE_AS_DICT["TAGS"]
	
	var ITEM = load(CREATE_TAGS_PREFAB).instantiate()
	%TAGS_CONTAINER.add_child(ITEM)
	for X in TAGS:
		var ITEM_TAG = load(VIEW_TAGS_PREFAB).instantiate()
		ITEM_TAG.TAG_NAME = X[0]
		%TAGS_CONTAINER.add_child(ITEM_TAG)
func AD_TAGS_CLOSED():
	%__INPUTBLOCKER__.visible = false
	for N in %TAGS_CONTAINER.get_children():
		%TAGS_CONTAINER.remove_child(N)
		N.queue_free()


func BTN_CHARA_PRESSED():
	%AD_CHARA.visible = true
	%__INPUTBLOCKER__.visible = true
	for N in %AD_CHARA_LIST.get_children():
		%AD_CHARA_LIST.remove_child(N)
		N.queue_free()
	var FILE_DATA = FileAccess.open(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/CONFIG.json",  FileAccess.READ);
	var JSON_STRING = FILE_DATA.get_as_text()
	var FILE_AS_DICT = JSON.parse_string(JSON_STRING)
	var CHARA = FILE_AS_DICT["CHARACTERS"]
	
	var ITEM = load(CREATE_CHARA_PREFAB).instantiate()
	%AD_CHARA_LIST.add_child(ITEM)
	for X in CHARA:
		var ITEM_CHARA = load(VIEW_CHARA_PREFAB).instantiate()
		ITEM_CHARA.CHARA_NAME = X
		%AD_CHARA_LIST.add_child(ITEM_CHARA)
func AD_CHARA_CLOSED():
	%__INPUTBLOCKER__.visible = false
	for N in %AD_CHARA_LIST.get_children():
		%AD_CHARA_LIST.remove_child(N)
		N.queue_free()


func BTN_FILTER_PRESSED():
	%AD_FILTER.visible = true
	%__INPUTBLOCKER__.visible = true
	for N in %Tag_List.get_children():
		%Tag_List.remove_child(N)
		N.queue_free()
	for N in %Chara_List.get_children():
		%Chara_List.remove_child(N)
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
		%Tag_List.add_child(ITEM)
	for CHARA in CHARAS:
		var ITEM = load(CUSTOM_CHECKBOX).instantiate()
		ITEM.set_text(CHARA)
		for X in Global.POPULATE_CHARAS:
			if(CHARA == X):
				ITEM.set_pressed(true)
		%Chara_List.add_child(ITEM)
func AD_FILTER_CLOSED():
	%__INPUTBLOCKER__.visible = false
	Global.POPULATE_TAGS = []
	Global.POPULATE_CHARAS = []
	for TAG in %Tag_List.get_children():
		if(TAG.is_pressed()):
			Global.POPULATE_TAGS.append(TAG.get_text())
	for CHARA in %Chara_List.get_children():
		if(CHARA.is_pressed()):
			Global.POPULATE_CHARAS.append(CHARA.get_text())
	Global.POPULATE = true

func BTN_RESET_FILTERS_PRESSED():
	%__INPUTBLOCKER__.visible = false
	%AD_FILTER.visible = false
	Global.POPULATE_TAGS = []
	Global.POPULATE_CHARAS = []
	Global.POPULATE = true

func BTN_APPLY_PRESSED():
	await CHECK_APPLIED_MODS()
	for NAME in Global.MODS_TO_APPLY:
		DirAccess.copy_absolute(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"]+"/"+NAME+"/"+NAME+".pak", Global.SAVE_DATA["GAME_PATH"] + r"/RED/Content/Paks/~MODS/DUMH"+"/"+NAME+".pak")
		DirAccess.copy_absolute(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"]+"/"+NAME+"/"+NAME+".sig", Global.SAVE_DATA["GAME_PATH"] + r"/RED/Content/Paks/~MODS/DUMH"+"/"+NAME+".sig")
		print("Applyed mod " + NAME)
	for NAME in Global.MODS_TO_UNAPPLY:
		DirAccess.remove_absolute(Global.SAVE_DATA["GAME_PATH"] + r"/RED/Content/Paks/~MODS/DUMH"+"/"+NAME+".pak")
		DirAccess.remove_absolute(Global.SAVE_DATA["GAME_PATH"] + r"/RED/Content/Paks/~MODS/DUMH"+"/"+NAME+".sig")
		print("Removed mod " + NAME)
	Global.MODS_TO_APPLY = []
	Global.MODS_TO_UNAPPLY = []
	await CHECK_APPLIED_MODS()
	Global.POPULATE = true

func BTN_SETTINGS_PRESSED():
	CHANGE_DISPLAYED_WINDOW([],[%SETTINGS])

func BTN_SETTINGS_RETURN_PRESSED():
	CHANGE_DISPLAYED_WINDOW([%SETTINGS],[])

func BTN_SETTINGS_DUMP_PRESSED():
	%__INPUTBLOCKER__.show()
	%CONFIRM_DIALOG_CUSTOM.show()
	%CDC_TITLE.text = "WARINING!"
	%CDC_MSG.text = "Are you sure you want dump your mods into ~MODS. (Destructive)"
	var CONFIRMED = await %CONFIRM_DIALOG_CUSTOM.Pressed
	if(CONFIRMED):
		var LIST = await Global.LIST_MODS_BY_INDEX()
		Global.MODS_TO_APPLY = []
		Global.MODS_TO_UNAPPLY = []
		Global.MODS_APPLYED = []
		for NAME in LIST:
			await DirAccess.copy_absolute(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"]+"/"+NAME[0]+"/"+NAME[0]+".pak", Global.SAVE_DATA["GAME_PATH"] + r"/RED/Content/Paks/~MODS/DUMH"+"/"+NAME[0]+".pak")
			await DirAccess.copy_absolute(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"]+"/"+NAME[0]+"/"+NAME[0]+".sig", Global.SAVE_DATA["GAME_PATH"] + r"/RED/Content/Paks/~MODS/DUMH"+"/"+NAME[0]+".sig")
			await DirAccess.remove_absolute(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"]+"/"+NAME[0]+"/"+NAME[0]+".sig")
			await DirAccess.remove_absolute(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"]+"/"+NAME[0]+"/"+NAME[0]+".pak")
			await DirAccess.remove_absolute(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"]+"/"+NAME[0]+"/DATA.json")
			await DirAccess.remove_absolute(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"]+"/"+NAME[0])
			print("Moved to ~MODS "+ NAME[0])
		await CHECK_APPLIED_MODS()
		Global.POPULATE = true
	%__INPUTBLOCKER__.hide()
	%CONFIRM_DIALOG_CUSTOM.hide()
func BTN_SETTINGS_CLONE_DUMP_PRESSED():
	%__INPUTBLOCKER__.show()
	%CONFIRM_DIALOG_CUSTOM.show()
	%CDC_TITLE.text = "WARINING!"
	%CDC_MSG.text = "Are you sure you want dump your mods into ~MODS. (NON-Destructive)"
	var CONFIRMED = await %CONFIRM_DIALOG_CUSTOM.Pressed
	if(CONFIRMED):
		var LIST = await Global.LIST_MODS_BY_INDEX()
		Global.MODS_TO_APPLY = []
		Global.MODS_TO_UNAPPLY = []
		Global.MODS_APPLYED = []
		for NAME in LIST:
			await DirAccess.copy_absolute(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"]+"/"+NAME[0]+"/"+NAME[0]+".pak", Global.SAVE_DATA["GAME_PATH"] + r"/RED/Content/Paks/~MODS/DUMH"+"/"+NAME[0]+".pak")
			await DirAccess.copy_absolute(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"]+"/"+NAME[0]+"/"+NAME[0]+".sig", Global.SAVE_DATA["GAME_PATH"] + r"/RED/Content/Paks/~MODS/DUMH"+"/"+NAME[0]+".sig")
			print("Moved to ~MODS "+ NAME[0])
		await CHECK_APPLIED_MODS()
		Global.POPULATE = true
	%__INPUTBLOCKER__.hide()
	%CONFIRM_DIALOG_CUSTOM.hide()
func BTN_SETTINGS_HARD_RESET_PRESSED():
	%__INPUTBLOCKER__.show()
	%CONFIRM_DIALOG_CUSTOM.show()
	%CDC_TITLE.text = "WARINING!"
	%CDC_MSG.text = "Are you sure you want to do a hard reset."
	var CONFIRMED = await %CONFIRM_DIALOG_CUSTOM.Pressed
	if(CONFIRMED):
		Global.HARD_RESET()
		get_tree().quit()
	%__INPUTBLOCKER__.hide()
	%CONFIRM_DIALOG_CUSTOM.hide()
	
	
var MODSLIST_PATHS_IMPORT = []
var MODSLIST_PATHS_DEEPER = []
func BTN_IMPORT_PRESSED() -> void:
	%__INPUTBLOCKER__.show()
	%CONFIRM_DIALOG_CUSTOM.show()
	%CDC_TITLE.text = "WARINING!"
	var FILEPATH = %TE_IMPORT.get_text()
	%CDC_MSG.text = "Are you sure you want to import mods from " + FILEPATH + "."
	var CONFIRMED = await %CONFIRM_DIALOG_CUSTOM.Pressed
	if(CONFIRMED):
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
	%__INPUTBLOCKER__.hide()
	%CONFIRM_DIALOG_CUSTOM.hide()
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


func BTN_SAVE_SLOTS_PRESSED():
	var SAVE_SLOTS_MAKER = load(SAVE_SLOTS_MAKER_PREFAB).instantiate()
	%SAVE_SLOTS_MANAGER_VBOX.add_child(SAVE_SLOTS_MAKER)
	%SAVE_SLOTS_MANAGER.show()
	%__INPUTBLOCKER__.show()


func SAVE_SLOTS_CLOSED():
	%SAVE_SLOTS_MANAGER.hide()
	%__INPUTBLOCKER__.hide()
	for CHILD in %SAVE_SLOTS_MANAGER_VBOX.get_children():
		CHILD.queue_free()

func BTN_UPDATE_PRESSED():
	CONFIRMED_DOWNLOAD_INSTRUCTIONS.emit(true)
func BTN_DECLINE_UPDATE_PRESSED():
	CONFIRMED_DOWNLOAD_INSTRUCTIONS.emit(false)
	%CC_UPDATE_AVAILABLE.hide()
	%__INPUTBLOCKER__.hide()
