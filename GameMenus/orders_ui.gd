class_name OrdersUI extends Control
@onready var day_end_progress_bar: TextureProgressBar = %DayEndProgressBar
@onready var orders_conatiner: Control = %OrdersConatiner
@onready var orders_label: Label = %OrdersLabel
const ORDER_CONTAINER = preload("uid://k3tl7w7ijt3x")
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_player_2: AnimationPlayer = $AnimationPlayer2

@onready var day_info_panel: PanelContainer = %DayInfoPanel
@onready var day_number_label: Label = %DayNumberLabel
@onready var required_orders_label: Label = %RequiredOrdersLabel
@onready var press_to_start_label: Label = %PressToStartLabel
@onready var day_end_progress_text: Label = %DayEndProgressText

@onready var count_down_label: Label = %CountDownLabel
@onready var game_state_label: Label = %GameStateLabel

@onready var day_progress: VBoxContainer = %DayProgress

var count_down_number:int
func _ready() -> void:
	_clear()
	day_info_panel.hide()
	day_progress.hide()
	orders_conatiner.hide()
	count_down_label.hide()
	game_state_label.hide()
	

func set_day_end_progress(value:float)->void:
	day_end_progress_bar.value = value
	
func set_time_remaining(value:float)->void:
	var minutes:int = floori(value / 60) 
	var secs = int(value) % 60
	day_end_progress_text.text = "%d:%02d" %[minutes,secs]

func set_day_state_label(state:String)->void:
	game_state_label.show()
	game_state_label.text = state
	animation_player_2.play("day_state_fadein")



func hide_day_state_label()->void:
	game_state_label.hide()

func show_progress()->void:
	day_progress.show()
	orders_conatiner.show()

func hide_progress()->void:
	day_progress.hide()
	orders_conatiner.hide()

func hide_animation_label()->void:
	count_down_label.visible =false
	hide_day_state_label()

func show_animation_label()->void:
	count_down_label.visible =true
	


func set_count_down_bounce(value:int)->void:
	if count_down_number == value:
		return
	count_down_number = value
	count_down_label.text = str(value)
	animation_player.stop()
	animation_player.play("countdown")

func spawn_order(order:CustomerOrder)->void:
	_clear()
	var instance = ORDER_CONTAINER.instantiate()
	orders_conatiner.add_child(instance)
	instance.set_up(order)
	

func _clear()->void:
	for i in orders_conatiner.get_children():
		i.queue_free()

func set_correct_orders_number(number:int,needed:int)->void:
	orders_label.text = tr("UI_ORDERS")+":%d/%d"%[number,needed]

func unset_day_info()->void:
	day_info_panel.visible = false

func set_day_info(day_number:int,required_number_of_orders:int)->void:
	day_info_panel.visible = true
	var key = GameManager.systems.player_input_detector.get_key_input_string_for_action("interact")
	var press_to_start_string:String = tr("UI_PRESS_TO_START").format({"button":key}) 
	press_to_start_label.text = press_to_start_string
	var day_string = tr("UI_DAY_NUMBER")+" "+str(day_number)
	var num_to_succeed = tr("UI_REQUIRED_ORDERS_NUMBER")+":" +str(required_number_of_orders)
	day_number_label.text = day_string
	required_orders_label.text = num_to_succeed
	
