class_name HierarchicalStateNode extends StateNode


@export var default:StateNode

var current_state:StateNode
func get_action_string()->String:
	if current_state:
		return current_state.get_action_string()
	else:
		return "thinking" 

func get_current_state()->StateNode:
	return current_state.get_current_state()

func get_state_and_child()->String:
	return name+"/"+ current_state.get_state_and_child()

func initialize(state_machine: StateMachine)->void:
	for i:StateNode in get_children():
		i.transition.connect(tranisition_to)
		i.initialize(state_machine)

func start()->void:
	for i:StateNode in get_children():
		i.start()


func on_enter()->void:
	set_state(default)


@warning_ignore("unused_parameter")
func update_self(delta:float)->void:
	pass

func update_child(delta:float)->void:
	if current_state:
		current_state.on_update(delta)
		

func on_update(delta:float)->void:
	
	update_child(delta)
	update_self(delta)


func on_self_transition()->void:
	pass

func on_child_transition()->void:
	if current_state:
		current_state.on_transition()
	

func on_transition()->void:
	on_child_transition()
	on_self_transition()

func tranisition_to(state_name:String)->void:
	if state_name.contains("*/"):
		transition.emit(state_name.substr(state_name.findn("*/")+2))
		return
	var node:StateNode = find_child(state_name)
	if node:
		set_state(node)



func set_state(state:StateNode):
	if state == current_state:
		return
	if current_state:
		current_state.on_exit()
	current_state = state
	current_state.on_enter()

func is_in_state(state_name:String)->bool:
	return name == state_name or current_state.is_in_state(state_name)

func is_state(state_name:String)->bool:
	return current_state.is_state(state_name)

func on_exit()->void:
	if current_state:
		current_state.on_exit()
	current_state = null
