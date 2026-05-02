class_name ItemHolder extends Node

signal item_changed(item:GameItem)
@warning_ignore("unused_signal")
signal item_added_to_plate(item:ItemData)
@warning_ignore("unused_signal")
signal plate_cleared
@warning_ignore("unused_signal")
signal top_viusal_removed
var held_item:GameItem

func set_held_item(new_item:GameItem)->void:
	if new_item.get_parent() !=null:
		new_item.get_parent().remove_child(new_item)
	add_child(new_item)
	held_item = new_item
	held_item.set_item_holder(self)
	item_changed.emit(held_item)

func get_item()->GameItem:
	return held_item

func get_item_data()->ItemData:
	if held_item == null:
		return null
	return held_item.data

func get_item_text()->String:
	if held_item == null:
		return ""
	return held_item.data.get_display_name()

func clear_held_item()->void:
	held_item = null
	item_changed.emit(null)
