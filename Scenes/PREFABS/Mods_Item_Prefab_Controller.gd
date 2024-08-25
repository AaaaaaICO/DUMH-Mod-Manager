extends Panel

#CHARACTER = ""
#DISPLAY_NAME = ""
#ORIGINAL_NAME = ""
#PINNED = ""
#TAGS = []

var SETTINGS

@onready var MODS_ITEM_TAG_PREFAB ="res://Scenes/PREFABS/Mods_Item_Tag_Prefab.tscn"

@onready var LBL_NAME = get_node("LBL_NAME")
@onready var LBL_PINNED = get_node("Pinned_Icon")
@onready var LBL_UNPINNED = get_node("UNPinned_Icon")
@onready var LOWER_BAR = get_node("Lower_bar")
@onready var LBL_ORIGINAL_NAME = get_node("Lower_bar/LBL_ORIGINAL_NAME")
@onready var TAG_CONTAINER = get_node("Lower_bar/FlowContainer")
@onready var ANIM_PLAYER = get_node("ANIM")

var AOVC = false
var AVC = false
var AONVC = false
@onready var APPLIED_OFF = get_node("MASK/PNL_SIDE_COLOR_APPLIED_OFF")
@onready var APPLIED_OFF_AP = get_node("MASK/AP_OFF")
@onready var APPLIED = get_node("MASK/PNL_SIDE_COLOR_APPLIED")
@onready var APPLIED_AP = get_node("MASK/AP_NULL")
@onready var APPLIED_ON = get_node("MASK/PNL_SIDE_COLOR_APPLIED_ON")
@onready var APPLIED_ON_AP = get_node("MASK/AP_ON")
@onready var SETTINGS_WINDOW = get_node("Window")
@onready var SETTINGS_NEW_NAME_WINDOW = get_node("AD_NewName")
@onready var SETTINGS_NEW_NAME_TEXT_EDIT_WINDOW = get_node("AD_NewName/MarginContainer/TextEdit")
@onready var SETTINGS_NEW_TAGS_WINDOW = get_node("AD_ChangeTags")
@onready var SETTINGS_NEW_TAGS_VBOX_WINDOW = get_node("AD_ChangeTags/MarginContainer/ScrollContainer/VBoxContainer")
@onready var SETTINGS_NEW_CHARA_WINDOW = get_node("AD_ChangeChara")
@onready var SETTINGS_NEW_CHARA_VBOX_WINDOW = get_node("AD_ChangeChara/MarginContainer/ScrollContainer/VBoxContainer")
@onready var SETTINGS_CHECKBOX_PREFAB = "res://Scenes/PREFABS/Simple_Checkbox.tscn"

@onready var SETTINGS_LBL_INDEX = get_node("Window/Panel/MarginContainer/VBoxContainer/LBL_CurrentIndex")

var OPENING = false
var HOVERING = false
var HOVERING_CLOSE = false

var MOD_APPLIED = false
var TO_APPLY = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	if(Global.MODS_APPLYED.has(SETTINGS["ORIGINAL_NAME"])):
		MOD_APPLIED = true
	else: MOD_APPLIED = false
	TO_APPLY = MOD_APPLIED
	await MOD_HELPER()
	
	SETTINGS_LBL_INDEX.set_text("Index = " + str(SETTINGS["INDEX"]))
	if(SETTINGS["CHARACTER"]):
		var CHARA_EXISTS = Global.CHECK_CHARA_EXISTS(SETTINGS["CHARACTER"])
		if(!CHARA_EXISTS):
			print("Character " + SETTINGS["CHARACTER"] + " no longer exists, removing")
			SETTINGS["CHARACTER"] = ""
			var Data_FILE = FileAccess.open(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/" +SETTINGS["ORIGINAL_NAME"] + "/DATA.json",  FileAccess.WRITE)
			var JSON_STRING = JSON.stringify(SETTINGS)
			Data_FILE.store_line(JSON_STRING)
			LBL_NAME.set_text(str(SETTINGS["DISPLAY_NAME"]))
		else:
			LBL_NAME.set_text(str(SETTINGS["CHARACTER"]) + " - " + str(SETTINGS["DISPLAY_NAME"]))
	else:
		LBL_NAME.set_text(str(SETTINGS["DISPLAY_NAME"]))
	LBL_ORIGINAL_NAME.set_text(SETTINGS["ORIGINAL_NAME"])
	var NUM_OF_TAGS = 0
	for TAG in SETTINGS["TAGS"]:
		var TAG_EXISTS = Global.CHECK_TAG_EXISTS(TAG)
		if(!TAG_EXISTS):
			print("Tag " + TAG + " no longer exists, removing")
			for X in SETTINGS["TAGS"]:
				if(X == TAG):
					SETTINGS["TAGS"].erase(X)
			var Data_FILE = FileAccess.open(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/" +SETTINGS["ORIGINAL_NAME"] + "/DATA.json",  FileAccess.WRITE)
			var JSON_STRING = JSON.stringify(SETTINGS)
			Data_FILE.store_line(JSON_STRING)
		if(NUM_OF_TAGS < 6 and TAG_EXISTS):
			var TAG_ITEM = load(MODS_ITEM_TAG_PREFAB).instantiate()
			TAG_ITEM.TAG_NAME = TAG
			var CLR = Global.RETURN_TAG_COLOR(TAG)
			TAG_ITEM.set_self_modulate(Color.html(CLR))
			TAG_CONTAINER.add_child(TAG_ITEM)
			NUM_OF_TAGS += 1
	if (SETTINGS["PINNED"]):
		LBL_PINNED.visible = true
	else: LBL_UNPINNED.visible = true






func _process(delta: float) -> void:
	if(HOVERING == true and Input.is_action_just_pressed("LEFT_CLICK")):
		TO_APPLY = !TO_APPLY
		await MOD_HELPER()
	if(HOVERING == true and Input.is_action_just_pressed("RIGHT_CLICK")):
		if(!Global.SETTINGS_WINDOW_OPEN):
			SETTINGS_WINDOW.visible = true
			Global.SETTINGS_WINDOW_OPEN = true
	if(HOVERING == false and HOVERING_CLOSE == false):
		HOVERING_CLOSE = true

	
func MOD_HELPER(): # SO MUCH EFFORT FOR LITTLE OUTCOME
	AOVC = true
	AVC = true
	AONVC = true
	if(MOD_APPLIED and TO_APPLY):
		APPLIED_ON.visible = true
		APPLIED.visible = false
		APPLIED_OFF.visible = false
		if(Global.MODS_TO_UNAPPLY.has(SETTINGS["ORIGINAL_NAME"])):
			Global.MODS_TO_UNAPPLY.erase(SETTINGS["ORIGINAL_NAME"])
	if(!MOD_APPLIED and TO_APPLY):
		APPLIED_ON.visible = false
		APPLIED.visible = true
		APPLIED_OFF.visible = false
		if(!Global.MODS_TO_APPLY.has(SETTINGS["ORIGINAL_NAME"])):
			Global.MODS_TO_APPLY.append(SETTINGS["ORIGINAL_NAME"])
		if(Global.MODS_TO_UNAPPLY.has(SETTINGS["ORIGINAL_NAME"])):
			Global.MODS_TO_UNAPPLY.erase(SETTINGS["ORIGINAL_NAME"])
	if(MOD_APPLIED and !TO_APPLY):
		APPLIED_ON.visible = false
		APPLIED.visible = false
		APPLIED_OFF.visible = true
		if(Global.MODS_TO_APPLY.has(SETTINGS["ORIGINAL_NAME"])):
			Global.MODS_TO_APPLY.erase(SETTINGS["ORIGINAL_NAME"])
		if(!Global.MODS_TO_UNAPPLY.has(SETTINGS["ORIGINAL_NAME"])):
			Global.MODS_TO_UNAPPLY.append(SETTINGS["ORIGINAL_NAME"])
	if(!MOD_APPLIED and !TO_APPLY):
		APPLIED_ON.visible = false
		APPLIED.visible = false
		APPLIED_OFF.visible = false
		if(Global.MODS_TO_APPLY.has(SETTINGS["ORIGINAL_NAME"])):
			Global.MODS_TO_APPLY.erase(SETTINGS["ORIGINAL_NAME"])
	
			
func LOWER_MOUSE_HOVER() -> void:
	OPENING = true
	HOVERING = true
	HOVERING_CLOSE = false
	ANIM_PLAYER.play("LOWER_OPEN")
	await ANIM_PLAYER.animation_finished
	OPENING = false
func LOWER_MOUSE_UNHOVER() -> void:
	HOVERING = false
	if(OPENING):
		await ANIM_PLAYER.animation_finished
	ANIM_PLAYER.play_backwards("LOWER_OPEN")


func ON_SETTINGS_WINDOW_CLOSE() -> void:
	SETTINGS_WINDOW.visible = false
	Global.SETTINGS_WINDOW_OPEN = false
	
func BTN_CHANGE_NAME_PRESSED() -> void:
	SETTINGS_NEW_NAME_WINDOW.visible = true
	SETTINGS_WINDOW.visible = false
func BTN_CHANGE_NAME_CONFIRMED_PRESSED() -> void:
	if(SETTINGS_NEW_NAME_TEXT_EDIT_WINDOW.get_text()):
		var FILE_DATA = FileAccess.open(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/" + SETTINGS["ORIGINAL_NAME"] + "/" + "DATA.json", FileAccess.READ);
		var JSON_STRING = FILE_DATA.get_as_text()
		var FILE_AS_DICT = JSON.parse_string(JSON_STRING)
		FILE_AS_DICT["DISPLAY_NAME"] = SETTINGS_NEW_NAME_TEXT_EDIT_WINDOW.get_text()
		var Data_FILE = FileAccess.open(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/" + SETTINGS["ORIGINAL_NAME"] + "/" + "DATA.json",  FileAccess.WRITE)
		JSON_STRING = JSON.stringify(FILE_AS_DICT)
		Data_FILE.store_line(JSON_STRING)
		Global.POPULATE = true
	Global.SETTINGS_WINDOW_OPEN = false

func BTN_CHANGE_TAGS_PRESSED() -> void:
	
	var FILE_DATA = FileAccess.open(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/CONFIG.json", FileAccess.READ);
	var JSON_STRING = FILE_DATA.get_as_text()
	var FILE_AS_DICT = JSON.parse_string(JSON_STRING)
	var TAGS = FILE_AS_DICT["TAGS"]
	for N in SETTINGS_NEW_TAGS_VBOX_WINDOW.get_children():
		SETTINGS_NEW_TAGS_VBOX_WINDOW.remove_child(N)
		N.queue_free()
	for TAG in TAGS:
		var ITEM = load(SETTINGS_CHECKBOX_PREFAB).instantiate()
		ITEM.set_text(TAG[0])
		for X in SETTINGS["TAGS"]:
			if(TAG[0] == X):
				ITEM.set_pressed(true)
		SETTINGS_NEW_TAGS_VBOX_WINDOW.add_child(ITEM)
	
	SETTINGS_NEW_TAGS_WINDOW.visible = true
	SETTINGS_WINDOW.visible = false
func BTN_CHANGE_TAGS_CONFIRMED_PRESSED() -> void:
	var LIST_OF_TAGS = []
	for CB in SETTINGS_NEW_TAGS_VBOX_WINDOW.get_children():
		if(CB.is_pressed()):
			LIST_OF_TAGS.append(CB.get_text())
	var FILE_AS_DICT = SETTINGS
	if(LIST_OF_TAGS):
		FILE_AS_DICT["TAGS"] = LIST_OF_TAGS
	else:
		FILE_AS_DICT["TAGS"] = []
	var Data_FILE = FileAccess.open(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/" + SETTINGS["ORIGINAL_NAME"] + "/" + "DATA.json",  FileAccess.WRITE)
	var JSON_STRING = JSON.stringify(FILE_AS_DICT)
	Data_FILE.store_line(JSON_STRING)
	Global.POPULATE = true
	Global.SETTINGS_WINDOW_OPEN = false

func BTN_CHANGE_CHARA_PRESSED() -> void:
	
	var FILE_DATA = FileAccess.open(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/CONFIG.json", FileAccess.READ);
	var JSON_STRING = FILE_DATA.get_as_text()
	var FILE_AS_DICT = JSON.parse_string(JSON_STRING)
	var CHARAS = FILE_AS_DICT["CHARACTERS"]
	for N in SETTINGS_NEW_CHARA_VBOX_WINDOW.get_children():
		SETTINGS_NEW_CHARA_VBOX_WINDOW.remove_child(N)
		N.queue_free()
	for CHARA in CHARAS:
		var ITEM = load(SETTINGS_CHECKBOX_PREFAB).instantiate()
		ITEM.set_text(CHARA)
		for X in SETTINGS["CHARACTER"]:
			if(CHARA == X):
				ITEM.set_pressed(true)
		SETTINGS_NEW_CHARA_VBOX_WINDOW.add_child(ITEM)
	
	SETTINGS_NEW_CHARA_WINDOW.visible = true
	SETTINGS_WINDOW.visible = false
func BTN_CHANGE_CHARA_CONFIRMED_PRESSED() -> void:
	var LIST_OF_CHARACTERS = []
	for CB in SETTINGS_NEW_CHARA_VBOX_WINDOW.get_children():
		if(CB.is_pressed()):
			LIST_OF_CHARACTERS.append(CB.get_text())
	var FILE_AS_DICT = SETTINGS
	if(LIST_OF_CHARACTERS):
		FILE_AS_DICT["CHARACTER"] = LIST_OF_CHARACTERS[0]
	else:
		FILE_AS_DICT["CHARACTER"] = ""
	var Data_FILE = FileAccess.open(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/" + SETTINGS["ORIGINAL_NAME"] + "/" + "DATA.json",  FileAccess.WRITE)
	var JSON_STRING = JSON.stringify(FILE_AS_DICT)
	Data_FILE.store_line(JSON_STRING)
	Global.POPULATE = true
	Global.SETTINGS_WINDOW_OPEN = false

func BTN_CHANGE_PIN_PRESSED() -> void:
	var FILE_AS_DICT = SETTINGS
	if(SETTINGS["PINNED"]): FILE_AS_DICT["PINNED"] = false
	else:                   FILE_AS_DICT["PINNED"] = true
	var Data_FILE = FileAccess.open(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/" + SETTINGS["ORIGINAL_NAME"] + "/" + "DATA.json",  FileAccess.WRITE)
	var JSON_STRING = JSON.stringify(FILE_AS_DICT)
	Data_FILE.store_line(JSON_STRING)
	Global.POPULATE = true
	Global.SETTINGS_WINDOW_OPEN = false

func BTN_CHANGE_INDEX_ADD_PRESSED() -> void:
	Global.ADD_INDEX_TO_MOD(SETTINGS["ORIGINAL_NAME"])
	Global.POPULATE = true
	Global.SETTINGS_WINDOW_OPEN = false
func BTN_CHANGE_INDEX_SUBTRACT_PRESSED() -> void:
	Global.SUBTRACT_INDEX_TO_MOD(SETTINGS["ORIGINAL_NAME"])
	Global.POPULATE = true
	Global.SETTINGS_WINDOW_OPEN = false

func APPLIED_OFF_VISIBILITY_CHANGED() -> void:
	if(AOVC):
		if(APPLIED_OFF.visible == true):
			APPLIED_OFF_AP.play("IN")
		else:
			APPLIED_OFF.visible = true
			APPLIED_OFF_AP.play("OUT")
			await APPLIED_OFF_AP.animation_finished
			APPLIED_OFF.visible = false
		AOVC = false


func APPLIED_VISIBILITY_CHANGED() -> void:
	if(AVC):
		if(APPLIED.visible == true):
			APPLIED_AP.play("IN")
		else:
			APPLIED.visible = true
			APPLIED_AP.play("OUT")
			await APPLIED_AP.animation_finished
			APPLIED.visible = false
		AVC = false


func APPLIED_ON_VISIBILITY_CHANGED() -> void:
	if(AONVC):
		if(APPLIED_ON.visible == true):
			APPLIED_ON_AP.play("IN")
		else:
			APPLIED_ON.visible = true
			APPLIED_ON_AP.play("OUT")
			await APPLIED_ON_AP.animation_finished
			APPLIED_ON.visible = false
		AONVC = false
