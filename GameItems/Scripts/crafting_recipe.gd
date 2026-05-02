class_name CraftingRecipe extends Resource

@export var required_items:Dictionary[ItemData,int]
@export var forbidden_items:Array[ItemData]
@export var output_item:ItemData

func is_valid(input_item:GameItem)->bool:
	if input_item is ItemPlate:
		var dict:Dictionary[ItemData,int]={}
		
		for item:ItemData in input_item.held_items:
			if dict.has(item):
				dict[item]+=1
			else:
				dict.set(item,1)
			if forbidden_items.has(item):
				
				return false
		
		for required:ItemData in required_items:
			var needed_amount = required_items[required]
			var provided = dict.get(required,0)
			if needed_amount > provided:
				
				return false
		
		return true
	return false
