extends StateMachine


func _ready():
	await get_tree().process_frame
	super._ready()
	process_mode =Node.PROCESS_MODE_INHERIT


func is_in_state(state_name:String)->bool:
	return current_state_node.is_in_state(state_name)

func is_state(state_name:String)->bool:
	return current_state_node.is_state(state_name)

func get_current_state()->StateNode:
	return current_state_node.get_current_state()

func get_action_string()->String:
	return current_state_node.get_action_string()

func get_state_and_child()->String:
	return current_state_node.get_state_and_child()
