extends Node

signal  on_window_mode_selected(index:int)

signal  on_resolution_selected(index:int)

signal  on_master_sound_selected(value:float)

signal  on_music_sound_selected(value:float)

signal  on_sfx_sound_selected(value:float)

var window_mode_index:int = 0
var resolution_index:int = 0
var master_volume:float = 0
var music_volume:float = 0
var sfx_volume:float = 0
var language_index:int = 0

var settings_configs:ConfigFile = ConfigFile.new()

const CONFIGPATH = "user://settings_configs.cfg"

const _master_bus_index =0
const _music_bus_index =1
const _sfx_bus_index =2

const _controls = "controls"
const _keybindings = "key_bindings"

const _graphics = "graphics"
const _window_mode = "window_mode"
const _resolution_mode = "resolution_mode"
const _language_index = "language"

const _volume = "volume"
const _master_volume = "master"
const _music_volume = "music"
const _sfx_volume = "sfx"



const LAUNGUAGE_ARRAY:Array[String]=[
	"GRAPHIC_GAME_LANGUAGE_ES_NAME",
	"GRAPHIC_GAME_LANGUAGE_EN_NAME"
]

const RESOLUTION_ARRAY:Array[Vector2i]=[
	Vector2i(1152,648),
	Vector2i(1200,720),
	Vector2i(1920,1080),
]

const RESOLUTION_DICTIONARY:Dictionary={
	"1152 X 648": RESOLUTION_ARRAY[0],
	"1200 X 720": RESOLUTION_ARRAY[1],
	"1920 X 1080": RESOLUTION_ARRAY[2],
}

const WINDOW_MODE_ARRAY:Array[String]=[
	"Full-screen",
	"Windowed Mode",
	"Borderless Window",
	"Borderless Full-screen"
]

func _ready() -> void:
	if !FileAccess.file_exists(CONFIGPATH):
		settings_configs.save(CONFIGPATH)
	else:
		settings_configs.load(CONFIGPATH)
	load_key_bindings()
	load_audio_settings()
	load_graphics_settings()
	load_language_settings()

var should_save:bool =false
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if should_save:
		should_save=false
		settings_configs.save(CONFIGPATH)

func get_variable(section:String,key:String,default:Variant = null)->Variant:
	return settings_configs.get_value(section,key,default)

func set_variable(section:String,key:String,value:Variant)->void:
	settings_configs.set_value(section,key,value)
	should_save = true

func load_key_bindings()->void:
	var bindings = InputMap.get_actions()
	for binding in bindings:
		var binding_key = get_variable(_keybindings,binding,-1)
		if binding_key !=-1:
			
			var action = InputMap.action_get_events(binding)[0]
			var key = binding_key as Key
			
			InputMap.action_erase_events(binding)
			
			action.keycode = binding_key
			action.physical_keycode =  key
			InputMap.action_add_event(binding,action)

func load_audio_settings()->void:
	master_volume = get_variable(_volume,_master_volume,0.5)
	music_volume = get_variable(_volume,_music_volume,0.5)
	sfx_volume = get_variable(_volume,_sfx_volume,0.5)
	
	AudioServer.set_bus_volume_db(_master_bus_index,linear_to_db(master_volume))
	AudioServer.set_bus_volume_db(_music_bus_index,linear_to_db(music_volume))
	AudioServer.set_bus_volume_db(_sfx_bus_index,linear_to_db(sfx_volume))

func load_graphics_settings()->void:
	window_mode_index = get_variable(_graphics,_window_mode,0)
	resolution_index = get_variable(_graphics,_resolution_mode,0)
	DisplayServer.window_set_size(RESOLUTION_ARRAY[resolution_index])
	match window_mode_index:
		0: #fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,false)
		1: #window mode
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,false)
		2: #borderless window
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,true)
		3: #borderless full screen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,true)


func set_resolution_index(index:int)->void:
	resolution_index = index
	DisplayServer.window_set_size(RESOLUTION_ARRAY[resolution_index])
	on_resolution_selected.emit(index)
	set_variable(_graphics,_resolution_mode,index)

func get_resolution_index()->int:
	return resolution_index

func set_window_mode_index(index:int)->void:
	window_mode_index = index
	
	match window_mode_index:
		0: #fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,false)
		1: #window mode
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,false)
		2: #borderless window
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,true)
		3: #borderless full screen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,true)
	on_window_mode_selected.emit(index)
	set_variable(_graphics,_window_mode,index)

func load_language_settings()->void:
	language_index = get_variable(_graphics,_language_index,0)
	const language_array = ["en","es"]
	TranslationServer.set_locale(language_array[language_index])

func get_language_index()->int:
	return language_index

func set_language_index(index:int)->void:
	language_index = index
	const language_array = ["en","es"]
	TranslationServer.set_locale(language_array[language_index])
	set_variable(_graphics,_language_index,language_index)


func get_window_mode_index()->int:
	return window_mode_index

func set_master_volume(value:float)->void:
	AudioServer.set_bus_volume_db(_master_bus_index,linear_to_db(value))
	master_volume = value
	on_master_sound_selected.emit(value)
	set_variable(_volume,_master_volume,value)

func get_master_volume()->float:
	return master_volume

func set_music_volume(value:float)->void:
	AudioServer.set_bus_volume_db(_music_bus_index,linear_to_db(value))
	music_volume = value
	on_music_sound_selected.emit(value)
	set_variable(_volume,_music_volume,value)

func get_music_volume()->float:
	return music_volume

func set_sfx_volume(value:float)->void:
	AudioServer.set_bus_volume_db(_sfx_bus_index,linear_to_db(value))
	sfx_volume = value
	on_sfx_sound_selected.emit(value)
	set_variable(_volume,_sfx_volume,value)


func get_sfx_volume()->float:
	return sfx_volume

func set_key_binding_for_action(action:String,key_binding:int)->void:
	set_variable(_controls,action,key_binding)

	
