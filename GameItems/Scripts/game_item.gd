class_name GameItem extends Node

var parent_holder:ItemHolder
var data:ItemData


static func create_item(_data:ItemData)->GameItem:
	if _data == null:
		return null
	var item = GameItem.new()
	item.data = _data
	return item

func set_item_holder(holder:ItemHolder)->void:
	if parent_holder!=null:
		if parent_holder.get_item() == self:
			parent_holder.clear_held_item()
	parent_holder = holder

func get_holder()->ItemHolder:
	return parent_holder

func delete_self()->void:
	if parent_holder!=null:
		parent_holder.clear_held_item()
	parent_holder = null
	queue_free()
