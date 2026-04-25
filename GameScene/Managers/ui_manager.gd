class_name UIManager extends Node
@onready var in_world_ui: Node2D = $InWorldUI

@onready var pause_screen_ui: Control = %PauseScreenUI
@onready var game_options: Control = %GameOptions
@onready var dynamic_ui: Control = %DynamicUI
@onready var transition_screen: CanvasLayer = $TransitionScreen
signal scene_transition_callback

func _ready() -> void:
	call_deferred("_start")
const GAME_THEME = preload("uid://cg5ck2xb78ke7")

func _start()->void:
	GameManager.get_input_detector().pause_requested.connect(_handle_escape_request)
	GameManager.current.game_paused.connect(show_pause_screen)
	GameManager.current.game_unpaused.connect(hide_pause_screen)
	if game_options:
		game_options.close_requested.connect(hide_options_menu)
	GameManager.scene_manager.new_level_loaded.connect(clear_in_world_ui)
	if transition_screen:
		transition_screen.scene_transition_callback.connect(_emit_call_back)
	

var current_menu:BaseCloseableUI
func spawn_in_dynamic_ui(menu:PackedScene, override_id:String = "")->BaseCloseableUI:
	if menu == null:
		printerr("hey dummy you forgot to set up this menu with id: %s fix this!"%override_id)
		print_stack()
		return
	var new_instance = menu.instantiate() as BaseCloseableUI
	if new_instance:
		if current_menu:
			_force_close_current_menu()
		if override_id !="":
			new_instance.unique_ID = override_id
		dynamic_ui.add_child(new_instance)
		
		current_menu = new_instance
		current_menu.close_requested.connect(_force_close_current_menu)
		current_menu.on_open()
	return new_instance

func close_request_for_dynamic_menu(id:String)->void:
	if !current_menu:
		return
	elif current_menu.unique_ID == id:
		_force_close_current_menu()
	
func _force_close_current_menu()->void:
	current_menu.menu_closing.emit()
	current_menu.on_close()
	current_menu.queue_free()

func _handle_escape_request()->void:
	if current_menu != null:
		_force_close_current_menu()
	elif game_options.visible:
		hide_options_menu()
	else:
		GameManager.toggle_pause()
	
	get_viewport().set_input_as_handled()

func spawn_in_world_ui(text, at_position:Vector2)->void:
	if text is String:
		clear_in_world_ui()
		
		var rich_text_label = RichTextLabel.new()
		rich_text_label.fit_content = true
		rich_text_label.bbcode_enabled =true
		rich_text_label.autowrap_mode = TextServer.AUTOWRAP_OFF
		rich_text_label.push_font_size(8)
		rich_text_label.append_text(text)
		
		in_world_ui.add_child(rich_text_label)
		rich_text_label.theme = GAME_THEME
		rich_text_label.update_minimum_size()
		rich_text_label.global_position = at_position -(rich_text_label.size/2)
	elif text is Node2D or text is Control:
		clear_in_world_ui()
		in_world_ui.add_child(text)
		text.global_position = at_position
		if text is Control:
			text.theme = GAME_THEME

func clear_in_world_ui()->void:
	for i in in_world_ui.get_children():
		i.queue_free()





func make_transition(transition_id:String)->void:
	transition_screen.make_transition(transition_id)


func _emit_call_back()->void:
	scene_transition_callback.emit()

func show_pause_screen()->void:
	pause_screen_ui.show()

func hide_pause_screen()->void:
	pause_screen_ui.hide()

func show_options_menu()->void:
	game_options.show()

func hide_options_menu()->void:
	game_options.hide()
