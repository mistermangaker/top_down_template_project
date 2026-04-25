class_name PlayerState extends StateNode

var player:Player
var visuals:EntityVisuals
var input:PlayerInputControls


func initialize(statem_machine: StateMachine)->void:
	super.initialize(statem_machine)
	player = statem_machine.get_parent()
	input = GameManager.systems.player_input_detector
	visuals = player.agent_visuals
