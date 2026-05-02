class_name NPC_OrderDropPool extends Resource

@export var npc_orders:Dictionary[BaseOrder,float]

@export var npcs:Array[PackedScene]


func get_npc_and_order()->NPC:
	var npc_instance = null
	if randf() <0.01:
		npc_instance = preload("uid://d271arbs74f63").instantiate() as NPC
	else:
		npc_instance = npcs.pick_random().instantiate() as NPC
	if npc_instance.has_no_custom_orders():
		var npc_order = get_customer_order()
		npc_instance.npcs_order = npc_order
	
	return npc_instance


func get_customer_order()->CustomerOrder:
	var order = get_weighted_drop(npc_orders)
	if order is CustomerOrder:
		return order
	elif order is CustomerOrderCategory:
		return order.generate_order()
	return npc_orders.keys().pick_random()

func get_weighted_drop(dict:Dictionary)->Variant:
	var items = dict.keys()

	var weights = PackedFloat32Array(dict.values()) 
		
	var rng = RandomNumberGenerator.new()
	rng.randomize()
		
	var index = rng.rand_weighted(weights)
	return items[index]
