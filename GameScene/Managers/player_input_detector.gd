class_name PlayerInputControls extends Node

signal pause_requested

var left_click_is_pressed: bool = false
var right_click_is_pressed:bool= false
var left_click_was_just_pressed:bool=false
var right_click_was_just_pressed:bool=false
var left_click_was_just_released:bool=false
var right_click_was_just_released:bool=false


func _input(input: InputEvent) -> void:
	if input is InputEventMouseButton:
		if input.button_index == MOUSE_BUTTON_LEFT:
			if input.pressed:
				if !left_click_is_pressed:
					left_click_was_just_pressed = true
				left_click_was_just_released = false
				left_click_is_pressed = true
			elif input.is_released():
				if left_click_is_pressed:
					left_click_was_just_released = true
				left_click_was_just_pressed =false
				left_click_is_pressed = false
			
		elif input.button_index == MOUSE_BUTTON_RIGHT:
			if input.pressed:
				if !right_click_is_pressed:
					right_click_was_just_pressed = true
				right_click_was_just_released = false
				right_click_is_pressed = true
			elif input.is_released():
				if right_click_is_pressed:
					right_click_was_just_released = true
				right_click_was_just_pressed = false
				right_click_is_pressed = false
	

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode ==Key.KEY_ESCAPE:
			if event.pressed:
				pause_requested.emit()

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	left_click_was_just_pressed=false
	right_click_was_just_pressed=false
	left_click_was_just_released=false
	right_click_was_just_released=false

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	var x = Input.get_axis("move_left","move_right")
	var y = Input.get_axis("move_forward","move_backward")
	movement_vector = Vector2(x,y)
	

var movement_vector:Vector2

func get_movement_direction()->Vector2:
	return movement_vector.normalized()

func get_movement_input()->Vector2:
	return Vector2()

func get_left_mouse_input()->bool:
	if mouse_is_over_ui():
		return false
	return left_click_is_pressed

func get_right_mouse_input()->bool:
	if mouse_is_over_ui():
		return false
	return right_click_is_pressed

func mouse_is_over_ui()->bool:
	return get_viewport().gui_get_hovered_control() !=null

func is_interaction_key_pressed()->bool:
	return Input.is_action_pressed("interact")
func is_interaction_key_just_pressed()->bool:
	return Input.is_action_just_pressed("interact")

func get_key_input_string_for_action(event_name:String)->String:
	var event = InputMap.action_get_events(event_name)[0] as InputEventKey
	var keycode = DisplayServer.keyboard_get_keycode_from_physical(event.physical_keycode)
	return OS.get_keycode_string(keycode)
