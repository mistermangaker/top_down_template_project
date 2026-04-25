class_name Player extends Entity
@export var interactable_detector: InteractableDetector 
@onready var state_machine: Node = $StateMachine

static var instance:Player

func _ready() -> void:
	interactable_detector.new_closest_detected.connect(_on_interactable_detector_new_closest_detected)
	interactable_detector.no_closest_detected.connect(_on_interactable_detector_no_closest_detected)


func _enter_tree() -> void:
	instance = self

func _on_interactable_detector_new_closest_detected(object: InteractableObject) -> void:
	#print(object.get_interactable_text(),object.get_interactable_text_location())
	GameManager.ui_manager.spawn_in_world_ui(object.get_interactable_text(),object.get_interactable_text_location())


func _on_interactable_detector_no_closest_detected() -> void:
	GameManager.ui_manager.clear_in_world_ui()


func get_closest_interactable_object()->InteractableObject:
	return interactable_detector.closest


func orient(dir:EntityVisuals.FacingDirection)->void:
	agent_visuals.facing_direction = dir

func enable()->void:
	state_machine.call_deferred("transition_to","enabled")
	

func disable()->void:
	state_machine.call_deferred("transition_to","disabled")
	
func is_moving()->bool:
	return agent_visuals.is_moving

func get_facing_direction()->EntityVisuals.FacingDirection:
	return agent_visuals.facing_direction
