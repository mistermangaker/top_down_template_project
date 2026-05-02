extends BaseCloseableUI

@export var fridge_items:Array[ItemData]
@onready var item_container: VBoxContainer = %ItemContainer
const FRIDGE_ITEM_BUTTON = preload("uid://bvdq851xly3ed")

func _on_close_pressed() -> void:
	close_self()

func on_open()->void:
	make_items()

func _clear()->void:
	for i in item_container.get_children():
		i.queue_free()

func set_items(item:Array[ItemData])->void:
	fridge_items = item
	make_items()

func make_items()->void:
	_clear()
	for i in fridge_items:
		var button =FRIDGE_ITEM_BUTTON.instantiate()
		item_container.add_child(button)
		button.set_item(i)
		button.item_pressed.connect(item_selected)

func item_selected(item:ItemData)->void:
	if Player.instance.item_holder.get_item() is ItemPlate:
		var plate = Player.instance.item_holder.get_item() as ItemPlate
		plate.add_item(item)
	else:
		var new_item = GameItem.create_item(item)
		Player.instance.item_holder.set_held_item(new_item)
	Player.instance.reset_interactable_text()
	close_self()
