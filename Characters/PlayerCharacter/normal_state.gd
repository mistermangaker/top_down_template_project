extends Hierarchical_PlayerState

@warning_ignore("unused_parameter")
func update_self(delta:float)->void:
	if input.is_interaction_key_just_pressed():
		var object = player.get_closest_interactable_object()
		if object !=null:
			object.try_doing_interaction()
