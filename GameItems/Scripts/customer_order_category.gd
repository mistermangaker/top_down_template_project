class_name CustomerOrderCategory extends BaseOrder

@export var available_main_dishes:Dictionary[ItemData,float]
@export var max_main_dishe_variety_to_spawn:int =2
@export var max_main_dish_amount_to_order:int = 1
@export var available_side_dishes:Dictionary[ItemData,float]
@export var max_side_dish_variety_to_spawn:int =3
@export var max_side_dish_amount_to_order:int = 1
@export var available_drinks:Dictionary[ItemData,float]
@export var max_drinks_variety_to_spawn:int=2
@export var max_drinks_to_order:int = 2

func generate_order()->CustomerOrder:
	var customer_order = CustomerOrder.new()
	var num_to_order = randi_range(1,max_main_dish_amount_to_order)
	var number_of_drinks =  randi_range(0,max_drinks_variety_to_spawn)
	var number_of_sides =  randi_range(0,max_side_dish_variety_to_spawn)
	for i in range(num_to_order):
		var item = get_weighted_drop(available_main_dishes) 
		var number_to_order = randi_range(1,max_main_dish_amount_to_order)
		customer_order.required_items.set(item,number_to_order)
	
	for i in range(number_of_drinks):
		var item = get_weighted_drop(available_drinks) 
		var number_to_order = randi_range(1,max_drinks_to_order)
		if number_to_order>0:
			customer_order.required_items.set(item,number_to_order)
		
	for i in range(number_of_sides):
		var item = get_weighted_drop(available_side_dishes) 
		var number_to_order = randi_range(0,max_side_dish_amount_to_order)
		if number_to_order>0:
			customer_order.required_items.set(item,number_to_order)
	
	return customer_order



func get_weighted_drop(dict:Dictionary[ItemData,float])->Variant:
	var items = dict.keys()

	var weights = PackedFloat32Array(dict.values()) 
		
	var rng = RandomNumberGenerator.new()
	rng.randomize()
		
	var index = rng.rand_weighted(weights)
	return items[index]
