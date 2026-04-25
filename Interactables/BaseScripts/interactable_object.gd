extends StaticBody2D
class_name InteractableObject


@export var interactable_name:String = "interactable_object"
@export var interaction_verb:String = "interact"
@export var name_offset: Vector2

signal successful_interaction
signal failed_interaction

func _ready() -> void:
	on_interactable_ready()
	call_deferred("on_interactable_start")

func on_interactable_ready()->void:
	pass
func on_interactable_start()->void:
	pass


func get_interactable_text()->String:
	return _get_interaction_intro()

func get_interactable_text_location()->Vector2:
	return global_position + name_offset

func _get_interact_key_string()->String:
	return GameManager.systems.player_input_detector.get_key_input_string_for_action("interact")

func _get_interaction_intro()->String:
	var final:String = ""
	if can_interact():
		final = _get_can_do_interaction_text()
	else:
		final = _get_can_not_do_interaction_text()
	return final

func _get_can_do_interaction_text()->String:
	return "press: %s to %s with %s " % [_get_interact_key_string(),interaction_verb,interactable_name]

func _get_can_not_do_interaction_text()->String:
	return  "can't %s with %s " % [interaction_verb,interactable_name]
func should_be_visible()->bool:
	return can_interact()

func can_interact()->bool:
	return true

func try_doing_interaction()->void:
	if !should_be_visible():
		return
	if can_interact():
		_do_interaction_internal()
		_on_interaction_end()
		successful_interaction.emit()
	else:
		_cant_do_interaction_internal()
		failed_interaction.emit()

func _do_interaction_internal()->void:
	pass

func _cant_do_interaction_internal()->void:
	pass

func _on_interaction_end()->void:
	pass
