extends MenuInteractableObject

@export var crafting_recipes:Array[CraftingRecipe]

func post_spawn_in()->void:
	loaded_menu.set_crafting_recipes(crafting_recipes)

func play_close_audio()->void:
	if loaded_menu.item_crafted == false:
		popup_close_audio.play()
