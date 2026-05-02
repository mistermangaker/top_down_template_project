extends StateNode

var agent:NPC
var nav_mesh_agent:NavigationAgent2D
func initialize(state_machine: StateMachine)->void:
	super.initialize(state_machine)
	agent = state_machine.get_parent()
	nav_mesh_agent = agent.navigation_agent_2d



func on_enter()-> void:
	nav_mesh_agent.target_position = agent.target_location
	

@warning_ignore("unused_parameter")
func on_update(delta:float)-> void:
	if nav_mesh_agent.is_navigation_finished():
		return
	var path = nav_mesh_agent.get_next_path_position()
	var move = agent.global_position.direction_to(path)
	agent.velocity = move * agent.entity_move_speed
	agent.move_and_slide()
	agent.agent_visuals.update_facing_direction_4_way()

func on_transition() -> void:
	if nav_mesh_agent.is_navigation_finished():
		agent.orient(EntityVisuals.FacingDirection.north)
		agent.npc_reached_destination.emit()
		agent.velocity =Vector2.ZERO
		transition.emit("idle")
