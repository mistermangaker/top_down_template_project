class_name GameManager extends Node
signal game_paused
signal game_unpaused

@onready var _systems: GameSystems = $Systems
@onready var _scene_manager: SceneManager = $SceneManager
@onready var _ui_manager: UIManager = $UIManager
@export var starting_scene:PackedScene
static var systems:GameSystems
static var scene_manager:SceneManager
static var ui_manager:UIManager
static var current:GameManager

func _ready() -> void:
	current=self
	systems = _systems
	scene_manager = _scene_manager
	ui_manager = _ui_manager
	call_deferred("load_scene")

func load_scene()->void:
	scene_manager.load_scene(starting_scene)
static func toggle_pause()->void:
	set_pause(!current.get_tree().paused)

static func set_pause(paused:bool)->void:
	current.get_tree().paused = paused
	if current.get_tree().paused:
		current.game_paused.emit()
	else:
		current.game_unpaused.emit()

static func is_paused()->bool:
	return current.get_tree().paused

static func get_input_detector()->PlayerInputControls:
	return systems.player_input_detector

static func pause_game()->void:
	set_pause(true)

static func unpause_game()->void:
	set_pause(false)

static func quit_to_main_menu()->void:
	pass
