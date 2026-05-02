extends Node
class_name StateNode

@warning_ignore("unused_signal")
signal transition(state:String)



func is_in_state(state_name:String)->bool:
	return name == state_name

func is_state(state_name:String)->bool:
	return name == state_name

func get_current_state()->StateNode:
	return self

func get_action_string()->String:
	return name

func get_state_and_child()->String:
	return name

@warning_ignore("unused_parameter")
func initialize(state_machine: StateMachine)->void:
	pass

func start()->void:
	pass

func on_enter()-> void:
	pass

@warning_ignore("unused_parameter")
func on_update(delta:float)-> void:
	pass

func on_events()-> void:
	pass

func on_transition() -> void:
	pass

func on_exit() -> void:
	pass
