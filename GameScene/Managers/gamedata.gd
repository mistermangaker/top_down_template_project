class_name GameData extends Node


var dropped_item_dictionary:Dictionary[String,Dictionary]={}


func get_dropped_items(id:String):
	return dropped_item_dictionary.get(id)

func set_dropped_items(id:String,array:Dictionary)->void:
	dropped_item_dictionary.set(id,array)
