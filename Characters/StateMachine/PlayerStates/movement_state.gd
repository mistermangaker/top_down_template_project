extends PlayerState


@warning_ignore("unused_parameter")
func on_update(delta:float)-> void:
	var mov = input.get_movement_direction()
	player.velocity = mov *player.entity_move_speed
	player.move_and_slide()
	player.agent_visuals.update_facing_direction_4_way()

func on_transition() -> void:
	if !player.is_moving():
		transition.emit("on_idle")
