extends Node
class_name StateMachine

@export var log_debug: bool 
@export var initial_state_node: StateNode
var current_state_node :StateNode


func _ready():
	for node:StateNode in get_children():
		node.initialize(self)
		node.transition.connect(transition_to)
	
	start_nodes()


func start_nodes()-> void:
	for node:StateNode in get_children():
		node.start()
	enter_node(initial_state_node)

func transition_to(node_name:String)->void:
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
	
