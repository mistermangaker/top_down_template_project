extends InteractableObject


func should_be_visible()->bool:
	return !Player.instance._has_item()

func _do_interaction_internal()->void:
	var plate = ItemPlate.create_item()
	Player.instance.set_held_item(plate)
