class_name GameData extends Node


var todays_required_orders:int=0
var todays_successful_orders:int=0
@export var day_number:int = 0

func _ready() -> void:
	incriment_day()

@export var days_drop_pool:Array[NPC_OrderDropPool]

@export var required_orders:Array[int]=[]

func get_todays_drop_pool()->NPC_OrderDropPool:
	var modulo = day_number % days_drop_pool.size()
	return days_drop_pool[modulo]

func get_order_number_for_today(day:int)->int:
	var modulo = day % required_orders.size()
	return required_orders[modulo]

func incriment_day()->void:
	day_number+=1
	todays_required_orders = get_order_number_for_today(day_number)
	todays_successful_orders = 0
