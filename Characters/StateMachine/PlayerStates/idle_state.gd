extends PlayerState


func on_transition() -> void:
	if input.get_movement_direction() !=Vector2.ZERO:
		transition.emit("on_movement")
