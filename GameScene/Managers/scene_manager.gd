class_name SceneManager extends Node

signal new_level_loaded
var cached_level_data:PackedScene



func transition_to_scene(scene_path:String,transition_id:String)->void:
	
	if not ResourceLoader.exists(scene_path, "PackedScene"):
		printerr("level data is null\nyou forgot to set the level data didnt you?")
		print_stack()
		return
	var scene = ResourceLoader.load(scene_path) as PackedScene
	
	GameManager.ui_manager.make_transition(transition_id)
	await GameManager.ui_manager.scene_transition_callback
	load_scene(scene)


func load_scene(packed_scene:PackedScene)->void:
	if packed_scene == null:
		printerr("level data is null\nyou forgot to set the level data didnt you?")
		print_stack()
		return
	var loaded = packed_scene.instantiate() as GameLevel
	if loaded == null:
		printerr("loaded scene is not a game level!")
		print_stack()
		return
	cached_level_data = packed_scene
	if GameLevel.current:
		GameLevel.current.exit_level()
		GameLevel.current.queue_free()
	GameLevel.current = loaded
	add_child(GameLevel.current)
	GameLevel.current.enter_level()
	new_level_loaded.emit()

func reload_scene()->void:
	load_scene(cached_level_data)
