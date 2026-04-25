extends Node

var game_configs:ConfigFile = ConfigFile.new()
const CONFIGPATH = "user://game_configs.cfg"
const _keybindings = "key_bindings"
func _ready() -> void:
	if !FileAccess.file_exists(CONFIGPATH):
		game_configs.save(CONFIGPATH)
	else:
		game_configs.load(CONFIGPATH)
	#load_key_bindings()


var should_save:bool =false
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if should_save:
		should_save=false
		
		game_configs.save(CONFIGPATH)


func load_key_bindings()->void:
	var bindings = InputMap.get_actions()
	for binding in bindings:
		var binding_key = get_variable(_keybindings,binding,-1)
		if binding_key !=-1:
			print("found it %s %s" % [binding,str(binding_key)])
			var action = InputMap.action_get_events(binding)[0]
			var key = binding_key as Key
			
			InputMap.action_erase_events(binding)
			
			action.keycode = binding_key
			action.physical_keycode =  key
			InputMap.action_add_event(binding,action)


func get_variable(section:String,key:String,default:Variant = null)->Variant:
	return game_configs.get_value(section,key,default)

func set_variable(section:String,key:String,value:Variant)->void:
	game_configs.set_value(section,key,value)
	should_save = true
