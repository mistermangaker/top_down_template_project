class_name CustomerOrder extends BaseOrder
@export var required_items:Dictionary[ItemData,int]
@export var forbidden_items:Array[ItemData]



func is_valid(input_item:GameItem)->Dictionary[ItemData,int]:
	var failed_items:Dictionary[ItemData,int]={}
	if input_item is ItemPlate:
		var dict:Dictionary[ItemData,int]={}
		
		for item:ItemData in input_item.held_items:
			if dict.has(item):
				dict[item]+=1
			else:
				dict.set(item,1)
		for required:ItemData in required_items:
			var needed_amount = required_items[required]
			var provided = dict.get(required,0)
			
			if needed_amount > provided:
				failed_items.set(required,needed_amount-provided)
				
		
		return failed_items
	else:
		for required:ItemData in required_items:
			var needed_amount = required_items[required]
			var provided = 0
			
			if input_item.data == required:
				provided =1
			
			if needed_amount > provided:
				failed_items.set(required,needed_amount-provided)
				
		
	return failed_items
