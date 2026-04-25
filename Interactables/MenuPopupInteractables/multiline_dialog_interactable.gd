extends MenuInteractableObject
@export_multiline("test") var dialog:String

func post_spawn_in()->void:
	pass
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	loaded_menu.set_text(dialog)
