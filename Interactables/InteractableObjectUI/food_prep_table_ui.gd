extends BaseCloseableUI
@export var crafting_recipes:Array[CraftingRecipe]
@onready var button_container: VBoxContainer = %ButtonContainer

const PREP_TABLE_ITEM_BUTTON = preload("uid://cqnx4c51va4fx")
var item_crafted:bool
func on_open()->void:
	make_buttons()

func set_crafting_recipes(recipes:Array[CraftingRecipe])->void:
	crafting_recipes = recipes
	make_buttons()

func make_buttons()->void:
	clear()
	for i in crafting_recipes:
		var instance = PREP_TABLE_ITEM_BUTTON.instantiate()
		button_container.add_child(instance)
		instance.set_up(i)
		instance.item_pressed.connect(on_item_pressed)

func clear()->void:
	for i in button_container.get_children():
		i.queue_free()

func on_item_pressed(data:ItemData)->void:
	item_crafted=true
	Player.instance.item_holder.get_item().delete_self()
	var plate = ItemPlate.create_item()
	plate.add_item(data)
	Player.instance.set_held_item(plate)
	const KNIFE_CHOPPING = preload("uid://bjtrxhwjcy2c2")
	GameManager.ui_manager.ui_audio.play_file(KNIFE_CHOPPING)
	close_self()


func _on_button_pressed() -> void:
	close_self()
