extends Node
class_name StateMachine
signal initialized
var is_initialized:bool
@export var log_debug: bool 
@export var initial_state_node: StateNode
var current_state_node :StateNode


func _ready():
	for node:StateNode in get_children():
		node.initialize(self)
		node.transition.connect(transition_to)
	
	start_nodes()

func get_current_state()->StateNode:
	return current_state_node.get_current_state()

func start_nodes()-> void:
	for node:StateNode in get_children():
		node.start()
	is_initialized = true
	initialized.emit()
	enter_node(initial_state_node)

func transition_to(node_name:String)->void:
	if node_name.contains("/"):
		var index = node_name.findn("/")
		var start_name = node_name.substr(0,index)
		var state_name =node_name.substr(index+1)
		
		for node in get_children():
			if node.name == start_name:
				enter_node(node)
				if node is HierarchicalStateNode:
					node.tranisition_to(state_name)
			return
	for node:StateNode in get_children():
		if node.name == node_name:
			enter_node(node)
			return

func _physics_process(delta):
	if current_state_node !=null:
		current_state_node.on_update(delta)
		current_state_node.on_transition()

func enter_node(statenode:StateNode)->void:

	if current_state_node!=null:
		current_state_node.on_exit()
		
	current_state_node = statenode
	current_state_node.on_enter()
	
