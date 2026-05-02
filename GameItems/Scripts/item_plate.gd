class_name ItemPlate extends GameItem

var held_items:Array[ItemData]=[]
const PLATE = preload("uid://cp2tg2hxjfpyx")

static func create_item(_data:ItemData=PLATE)->GameItem:
	var plate = ItemPlate.new()
	plate.data = PLATE
	return plate

func plate_is_empty()->bool:
	return held_items.size()==0

func get_last_item()->ItemData:
	if held_items.size()==0:
		return null
	return held_items[held_items.size()-1]

func get_and_remove_last_item()->GameItem:
	var item_data = held_items.pop_back()
	if get_holder() !=null:
		get_holder().top_viusal_removed.emit()
	return GameItem.create_item(item_data)


func clear_all_items()->void:
	if get_holder() !=null:
		get_holder().plate_cleared.emit()
	held_items.clear()

func add_item(item)->void:
	if item is ItemData:
		held_items.append(item)
		if get_holder() !=null:
			get_holder().item_added_to_plate.emit(item)
	elif item is GameItem:
		if item is ItemPlate:
			_handle_plate(item)
			
		else:
			held_items.append(item.data)
			item.delete_self()
			if get_holder():
				get_holder().item_added_to_plate.emit(item.data)


func _handle_plate(item:ItemPlate)->void:
	
	if !item.held_items.is_empty():
		
		var item_data = item.held_items.pop_back()
		held_items.append(item_data)
		if get_holder() !=null:
			get_holder().item_added_to_plate.emit(item_data)
		
		if item.get_holder() !=null:
			item.get_holder().top_viusal_removed.emit()
		
