
class_name GameLevel extends Node

static var current:GameLevel

@export var player:Player

var game_is_running:bool

var doors:Array[Door]
static var data:LevelDataHandoff

func _ready() -> void:
	if player == null:
		player = get_tree().get_first_node_in_group("player")
	if !player:
		printerr("player not found")
		return
	player.visible = false
	player.disable()
	doors.clear()
	for door in get_tree().get_nodes_in_group("doors"):
		doors.append(door)
	

func enter_level()->void:
	if data !=null:
		init_player_location()
	player.visible = true
	player.enable()
	_connect_to_doors()



func exit_level()->void:
	player.visible = false
	player.disable()
	

func init_player_location()->void:
	if data ==null:
		return
	if data.door_id == "":
		player.orient(data.player_facing_direction)
		return
	for door in doors:
		if door.name == data.door_id:
			player.set_deferred("position",door.get_player_entry_vector())
			break
			
	player.orient(data.player_facing_direction)



func _player_entered_door(door:Door,transition_id:String)->void:
	transition_to_new_level(door.path_to_new_scene,transition_id,door.get_movement_dir(),door.entry_door_name)
	

func transition_to_new_level(path_to_new_scene:String,
transition_id:String,
facing_dir:EntityVisuals.FacingDirection
,entry_door_id:String="")->void:
	_disconnect_from_doors()
	data = LevelDataHandoff.new()
	data.door_id = entry_door_id
	data.player_facing_direction = facing_dir
	GameManager.scene_manager.transition_to_scene(path_to_new_scene,transition_id)

func _connect_to_doors()->void:
	for door:Door in doors:
		door.player_entered_door.connect(_player_entered_door)

func _disconnect_from_doors()->void:
	for door:Door in doors:
		door.player_entered_door.disconnect(_player_entered_door)
