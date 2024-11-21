extends Panel

signal MULTI_SELECT_CONFIRMED()

@onready var SETTINGS_CHECKBOX_PREFAB = "res://Scenes/PREFABS/Simple_Checkbox.tscn"

@onready var MASTER = get_tree().get_root().get_node("MASTER")
func _ready() -> void:
	if(Global.MULTI_SELECT_ACTIVE):
		%BTN_MULTISELECT.text = "Confirm selection"
	if(!Global.MULTI_SELECT_ACTIVE):
		%BTN_MULTISELECT.text = "Multiple select"
		
	var LIST = await Global.LIST_MODS_BY_INDEX()
	%LBL_NUM.text = "Number of mods : " + str(len(LIST))
	
func _process(delta: float) -> void:
	await get_tree().create_timer(0.5).timeout
	%LBL_NUMDISPLAYED.text = "Number of mods displayed: " + str(MASTER.get_node("%VBC_MODS_LIST").get_child_count()-1)

func BTN_UNAPPLY_PRESSED() -> void:
	var LIST = await Global.LIST_MODS_BY_INDEX()
	Global.MODS_TO_APPLY = []
	Global.MODS_TO_UNAPPLY = []
	Global.MODS_APPLYED = []
	for NAME in LIST:
		DirAccess.remove_absolute(Global.SAVE_DATA["GAME_PATH"] + r"\RED\Content\Paks\~MODS\DUMH"+"/"+NAME[0]+".pak")
		DirAccess.remove_absolute(Global.SAVE_DATA["GAME_PATH"] + r"\RED\Content\Paks\~MODS\DUMH"+"/"+NAME[0]+".sig")
		print("Removed mod " + NAME[0])
	
	Global.POPULATE = true

func CHECK_APPLIED_MODS():
	Global.MODS_APPLYED = []
	var DA = DirAccess.open(Global.SAVE_DATA["GAME_PATH"] + r"\RED\Content\Paks\~MODS\DUMH")
	for FILE in DA.get_files():
		if(FILE.contains(".pak")):
			Global.MODS_APPLYED.append(FILE.left(FILE.length() - 4))
			
			
func BTN_APPLY_ALL_PRESSED() -> void:
	var LIST = await Global.LIST_MODS_BY_INDEX()
	Global.MODS_TO_APPLY = []
	Global.MODS_TO_UNAPPLY = []
	Global.MODS_APPLYED = []
	for NAME in LIST:
		await DirAccess.copy_absolute(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"]+"/"+NAME[0]+"/"+NAME[0]+".pak", Global.SAVE_DATA["GAME_PATH"] + r"\RED\Content\Paks\~MODS\DUMH"+"/"+NAME[0]+".pak")
		await DirAccess.copy_absolute(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"]+"/"+NAME[0]+"/"+NAME[0]+".sig", Global.SAVE_DATA["GAME_PATH"] + r"\RED\Content\Paks\~MODS\DUMH"+"/"+NAME[0]+".sig")
		print("Applyed mod " + NAME[0])
	await CHECK_APPLIED_MODS()
	Global.POPULATE = true

func BTN_PRESET_PRESSED() -> void:
	var NAME = ""
	var LIST = Global.MODS_APPLYED
	LIST.append_array(Global.MODS_TO_APPLY)
	var INPUTBLOCKER = get_tree().get_root().get_node("MASTER").get_node("__INPUTBLOCKER__")
	var AD_PROFILE_NAME = INPUTBLOCKER.get_node("AD_PROFILE_NAME")
	AD_PROFILE_NAME.visible = true
	INPUTBLOCKER.visible = true
	await AD_PROFILE_NAME.confirmed
	NAME = AD_PROFILE_NAME.get_node("MarginContainer/TextEdit").get_text()
	if(!NAME or Global.CHECK_PRESET_EXISTS(NAME)):
		NAME = "Default Name" + str(randi_range(0, 100000))
	INPUTBLOCKER.visible = false
	AD_PROFILE_NAME.visible = false
	var FILE_DATA = FileAccess.open(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/CONFIG.json",  FileAccess.READ);
	var JSON_STRING = FILE_DATA.get_as_text()
	var FILE_AS_DICT = JSON.parse_string(JSON_STRING)
	var TO_APPEND = [
		NAME,
		LIST
	]
	print(TO_APPEND)
	FILE_AS_DICT["PRESETS"].append(TO_APPEND)
	var Data_FILE = FileAccess.open(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/CONFIG.json",  FileAccess.WRITE)
	JSON_STRING = JSON.stringify(FILE_AS_DICT)
	Data_FILE.store_line(JSON_STRING)
	Global.POPULATE = true


func BTN_REFRESH_PRESSED() -> void:
	Global.REFRESH_WINDOW = true


func BTN_MULTI_SELECT_PRESSED() -> void:
	Global.MULTI_SELECT_ACTIVE = !Global.MULTI_SELECT_ACTIVE
	if(Global.MULTI_SELECT_ACTIVE):
		%BTN_MULTISELECT.text = "Confirm selection"
	if(!Global.MULTI_SELECT_ACTIVE):
		%BTN_MULTISELECT.text = "Multiple select"
		%VBoxContainer_MULTI_SELECT.show()
		%VBoxContainer.hide()
		
	await MULTI_SELECT_CONFIRMED
	Global.MUTLI_SELECTED_MODS = []
	Global.POPULATE = true
	Global.SETTINGS_WINDOW_OPEN = false
	Global.REFRESH_WINDOW = true


func _on_btn_tags_pressed() -> void:
	pass # Replace with function body.

func _on_btn_characters_pressed() -> void:
	%AD_ChangeChara.show()
	var FILE_DATA = FileAccess.open(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/CONFIG.json", FileAccess.READ);
	var JSON_STRING = FILE_DATA.get_as_text()
	var FILE_AS_DICT = JSON.parse_string(JSON_STRING)
	var CHARAS = FILE_AS_DICT["CHARACTERS"]
	for N in %SETTINGS_NEW_CHARA_VB.get_children():
		%SETTINGS_NEW_CHARA_VB.remove_child(N)
		N.queue_free()
	print(CHARAS)
	for CHARA in CHARAS:
		var ITEM = load(SETTINGS_CHECKBOX_PREFAB).instantiate()
		ITEM.set_text(CHARA)
		%SETTINGS_NEW_CHARA_VB.add_child(ITEM)
		
		
func _on_btn_multiselect_pressed() -> void:
	MULTI_SELECT_CONFIRMED.emit()


func _on_ad_change_chara_confirmed() -> void:
	for x in Global.MUTLI_SELECTED_MODS: # Add multithreading?
		var LIST_OF_CHARACTERS = []
		for CB in %SETTINGS_NEW_CHARA_VB.get_children():
			if(CB.is_pressed()):
				LIST_OF_CHARACTERS.append(CB.get_text())
		var FILE_DATA = FileAccess.open(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/" + x + "/" + "DATA.json", FileAccess.READ);
		var JSON_STRING = FILE_DATA.get_as_text()
		var FILE_AS_DICT = JSON.parse_string(JSON_STRING)
		if(LIST_OF_CHARACTERS):
			FILE_AS_DICT["CHARACTER"] = LIST_OF_CHARACTERS[0]
		else:
			FILE_AS_DICT["CHARACTER"] = ""
		var Data_FILE_END = FileAccess.open(Global.SAVE_DATA["USER_MODS_FOLDER_PATH"] + "/" + FILE_AS_DICT["ORIGINAL_NAME"] + "/" + "DATA.json",  FileAccess.WRITE)
		var JSON_STRING_END = JSON.stringify(FILE_AS_DICT)
		Data_FILE_END.store_line(JSON_STRING_END)
