extends InteractableObject
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func should_be_visible()->bool:
	return Player.instance._has_item()

func _do_interaction_internal()->void:
	var item = Player.instance.item_holder.get_item()
	if item:
		animated_sprite_2d.play("open")
		item.delete_self()

func get_interactable_text()->String:
	var held_item_name = Player.instance.item_holder.get_item_text()
	var trash_text = tr("INTERACT_TRASH")
	trash_text = trash_text.format({"item":held_item_name,"interactable_object":get_interactable_name()})
	var interaction_start = tr("PRESS_TO_INTERACT_START")
	interaction_start = interaction_start.format({"button":_get_interact_key_string()})
	return interaction_start+" "+trash_text
