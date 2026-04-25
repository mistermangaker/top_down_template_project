extends InteractableObject
@export_enum("north","east","south","west") var entery_direction:int
@export_enum("fade_to_black") var transition_type:String
@export var path_to_level_data:String
@export var enterance_location_id:String
###if true then the enterance_location_id, transition_type, and enterydirection will be used, otherwise they will be ignord
@export var specify_location_and_orientation:bool = false


func _do_interaction_internal()->void:
	if specify_location_and_orientation:
		GameLevel.current.transition_to_new_level(
			path_to_level_data,
			transition_type,
			get_movement_dir(),
			enterance_location_id
			)
	else:
		var level = ResourceLoader.load(path_to_level_data) as LevelData
		GameManager.scene_manager.load_scene(level)


func get_movement_dir():
	match entery_direction:
		0:
			return EntityVisuals.FacingDirection.south
		1:
			return EntityVisuals.FacingDirection.west
		2:
			return EntityVisuals.FacingDirection.north
		3:
			return EntityVisuals.FacingDirection.east
