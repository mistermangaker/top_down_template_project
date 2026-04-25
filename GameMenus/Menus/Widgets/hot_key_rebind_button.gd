extends HBoxContainer
class_name HotKeyRebindButton
@onready var action_key_label: Label = $ActionKeyLabel
@onready var rebind_button: Button = $RebindButton

@export var action_name:String =""
@export var display_name:String = ""
@export var tool_tip:String = ""
func _ready() -> void:
	set_process_unhandled_key_input(false)
	rebind_button.toggle_mode = true
	rebind_button.toggled.connect(_rebind_toggled)
	set_action_name()
	set_text_for_key()
	if tool_tip !="":
		action_key_label.mouse_filter = Control.MOUSE_FILTER_STOP
		action_key_label.tooltip_text = tool_tip


func set_action_name()->void:
	if display_name == "":
		action_key_label.text = action_name.capitalize()
	else:
		action_key_label.text = display_name


func set_text_for_key()->void:
	var action_events = InputMap.action_get_events(action_name)
	if action_events.is_empty():
		printerr("the action name %s has not actions!"%action_name)
		print_stack()
		return
	var action_event = action_events[0]
	var key_text = OS.get_keycode_string(action_event.physical_keycode)
	rebind_button.text = "%s" % key_text


static var all_rebind_buttons:Array[HotKeyRebindButton]=[]

func _enter_tree() -> void:
	all_rebind_buttons.append(self)

func _exit_tree() -> void:
	all_rebind_buttons.erase(self)

func disable_button()->void:
	rebind_button.button_pressed = false
	

func _rebind_toggled(toggled_on:bool)->void:
	if toggled_on:
		rebind_button.text = "Press Any Key"
		for i in all_rebind_buttons:
			if i == self:
				continue
			i.disable_button()
	else:
		set_text_for_key()
	set_process_unhandled_key_input(toggled_on)


func _unhandled_key_input(event: InputEvent) -> void:
	
	rebind_action_key(event)
	disable_button()

func rebind_action_key(event: InputEvent)->void:
	InputMap.action_erase_events(action_name)
	InputMap.action_add_event(action_name,event)
	SystemSettings.set_key_binding_for_action(action_name,event.keycode)
	set_process_unhandled_key_input(false)
	set_text_for_key()
