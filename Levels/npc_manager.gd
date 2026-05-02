class_name NPC_Manager extends Node
@export var random_walkers:Array[PackedScene]
@onready var right_side: Node = $RightSide
@onready var left_side: Node = $LeftSide
@onready var timer: Timer = $Timer

var todays_drop_pool:NPC_OrderDropPool
func _ready() -> void:
	todays_drop_pool = GameManager.systems.game_data.get_todays_drop_pool()

func spawn_customer()->NPC:
	var agent:NPC = todays_drop_pool.get_npc_and_order()
	
	get_parent().add_child.call_deferred(agent)
	var spawn_pos = get_left_side_node_pos()
	if randf() >0.5:
		spawn_pos = get_right_side_node_pos()
	
	agent.global_position = spawn_pos
	await get_tree().process_frame
	agent.enable()
	await get_tree().process_frame
	return agent

func spawn_wandering_npc()->void:
	if !GameLevel.current.game_is_running:
		return
	var agent:NPC = random_walkers.pick_random().instantiate()
	get_parent().add_child.call_deferred(agent)
	var spawn_pos = get_left_side_node_pos()
	var despawn_pos = get_right_side_node_pos()
	if randf() >0.5:
		spawn_pos = get_right_side_node_pos()
		despawn_pos = get_left_side_node_pos()
		
	
	agent.global_position = spawn_pos
	await get_tree().process_frame
	agent.enable()
	await get_tree().process_frame
	agent.set_destination(despawn_pos)
	agent.npc_reached_destination.connect(agent.queue_free)

func get_left_side_node_pos()->Vector2:
	var random_node:Node2D = left_side.get_children().pick_random()
	return random_node.global_position

func get_right_side_node_pos()->Vector2:
	var random_node:Node2D = right_side.get_children().pick_random()
	return random_node.global_position

func get_random_map_edge()->Vector2:
	if randf() >0.5:
		return get_left_side_node_pos()
	else:
		return get_right_side_node_pos()
