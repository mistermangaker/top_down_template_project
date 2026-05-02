extends StateNode

var agent:NPC

func initialize(state_machine: StateMachine)->void:
	super.initialize(state_machine)
	agent = state_machine.get_parent()
	

func on_enter()-> void:
	agent.agent_visuals.play_animation(EntityVisuals.IDLE_ANIM)
