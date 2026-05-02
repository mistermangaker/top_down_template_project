class_name Player extends Entity
@export var interactable_detector: InteractableDetector 

@onready var audio_stream_player_2d: AudioStreamPlayer = $AudioStreamPlayer2D


##if present override the defualt sprite sheet with this on start up otherwise keeps the default
@export var override_sprite_sheet:SpriteFrames

static var instance:Player

func _ready() -> void:
	super._ready()
	interactable_detector.new_closest_detected.connect(_on_interactable_detector_new_closest_detected)
	interactable_detector.no_closest_detected.connect(_on_interactable_detector_no_closest_detected)
	if override_sprite_sheet:
		agent_visuals.set_sprite_frames(override_sprite_sheet)


func set_held_item(item:GameItem)->void:
	item_holder.set_held_item(item)
	

func _has_item()->bool:
	return item_holder.held_item !=null

func _enter_tree() -> void:
	instance = self

func _on_interactable_detector_new_closest_detected(object: InteractableObject) -> void:
	
	GameManager.ui_manager.spawn_in_world_ui(object.get_interactable_text(),object.get_interactable_text_location())


func _on_interactable_detector_no_closest_detected() -> void:
	GameManager.ui_manager.clear_in_world_ui()

func reset_interactable_text()->void:
	interactable_detector.reset_and_rescan()

func get_closest_interactable_object()->InteractableObject:
	return interactable_detector.closest
