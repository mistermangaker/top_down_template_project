extends Node
class_name OrderManager

signal order_failed(dict:Dictionary[ItemData,int])
@export var game_time:float = 500
@export var count_down_time:float = 5
@export var game_over_time:float = 5
@export var orders_needed_to_succeed:int = 5
@export var start_in_debug_mode:bool
var orders_ui:OrdersUI
var game_data:GameData

var correct_orders:int
var count_down_timer:float

var game_state:GameState
enum GameState{
	WaitingState,
	GameCountDown,
	GamePlaying,
	GameOver
}
var current_order:CustomerOrder


func _ready() -> void:
	orders_ui = GameManager.current.ui_manager.orders_ui
	game_data = GameManager.systems.game_data
	var day_number = game_data.day_number
	orders_needed_to_succeed = game_data.get_order_number_for_today(day_number)
	
	orders_ui.set_day_info(day_number,orders_needed_to_succeed)
	if start_in_debug_mode:
		await get_tree().process_frame
		_start_count_down()
		await get_tree().process_frame
		_start_game()
	elif day_number>1:
		await get_tree().process_frame
		if Player.instance:
				Player.instance.disable()
		_start_count_down()
	

func _start_count_down()->void:
	orders_ui.unset_day_info()
	orders_ui.set_day_state_label("UI_DAY_START")
	orders_ui.show_animation_label()
	game_state = GameState.GameCountDown
	count_down_timer = count_down_time

func _start_game()->void:
	orders_ui.hide_animation_label()
	orders_ui.show_progress()
	orders_ui.set_correct_orders_number(correct_orders,orders_needed_to_succeed)
	Player.instance.enable()
	game_state = GameState.GamePlaying
	count_down_timer = game_time
	GameLevel.current.game_is_running = true

func _process(delta: float) -> void:
	
	match game_state:
		GameState.WaitingState:
			orders_ui.hide_animation_label()
			if Player.instance:
				Player.instance.disable()
			
			if GameManager.systems.player_input_detector.is_interaction_key_just_pressed():
				_start_count_down()
			return
		GameState.GameCountDown:
			count_down_timer -= delta
			var count_down_int = int(count_down_timer)
			orders_ui.set_count_down_bounce(count_down_int)
			if count_down_timer <=0:
				_start_game()
			return
		GameState.GamePlaying:
			count_down_timer -= delta
			orders_ui.set_day_end_progress(count_down_normalized())
			orders_ui.set_time_remaining(count_down_timer)
			if count_down_timer <=0:
				orders_ui.set_day_state_label("UI_DAY_FINISHED")
				orders_ui.show_animation_label()
				game_state = GameState.GameOver
				count_down_timer = game_over_time
				Player.instance.disable()
				GameLevel.current.game_is_running = false
				for i in NPC.all_npcs:
					i.disable()
			return
		GameState.GameOver:
			orders_ui.hide_progress()
			var count_down_int = int(count_down_timer)
			orders_ui.set_count_down_bounce(count_down_int)
			count_down_timer -= delta
			if count_down_timer <=0:
				GameManager.scene_manager.swap_scene(preload("uid://b4nrvy7qewika"))
			return

func count_down_normalized()->float:
	return count_down_timer/game_time

func try_submit_order(item:GameItem)->bool:
	if item == null:
		return false
	
	var failed = current_order.is_valid(item)
	if failed.is_empty():
		game_data.todays_successful_orders += 1
		orders_ui.set_correct_orders_number(correct_orders,orders_needed_to_succeed)
		return true
	else:
		order_failed.emit(failed)
	return false

func set_new_order(customer_order:CustomerOrder)->void:
	current_order = customer_order
	orders_ui.spawn_order(customer_order)

func end_current_order()->void:
	current_order = null
	orders_ui._clear()
	
