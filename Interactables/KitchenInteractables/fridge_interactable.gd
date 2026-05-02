extends MenuInteractableObject
@onready var sprite_2d: Sprite2D = $Sprite2D
@export var open_texture:Texture2D = preload("uid://bsp4c8v10aict")
@export var closed_texture:Texture2D =  preload("uid://cfgx44tsbyr2y")

@export var fridge_items:Array[ItemData]
func on_interactable_start()->void:
	sprite_2d.texture = closed_texture


func can_interact()->bool:
	if Player.instance._has_item():
		if Player.instance.item_holder.get_item() is ItemPlate:
			return true
		return false
	return super.can_interact()


func post_spawn_in()->void:
	sprite_2d.texture = open_texture
	if !fridge_items.is_empty():
		loaded_menu.set_items(fridge_items)
	loaded_menu.menu_closing.connect(on_closed)

func on_closed()->void:
	sprite_2d.texture = closed_texture

func _get_can_not_do_interaction_text()->String:
	return "hands full"
