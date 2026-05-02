extends InteractableObject
@export var order_manager:OrderManager
@export var npc_manager:NPC_Manager
@onready var success_panel: PanelContainer = %SuccessPanel
@onready var failure_panel: PanelContainer = %FailurePanel

@onready var failed_order_container: VBoxContainer = %FailedOrderContainer
@onready var interaction_spot: Node2D = $InteractionSpot
@onready var timer: Timer = $Timer
@export var on_failure_audio_Stream:AudioStream
@export var on_success_audio_Stream:AudioStream
var _can_interact:bool = true

var cached_npc:NPC
const FAILED_ORDER_PART_UI = preload("uid://bpqos5s5fxunl")

func on_interactable_ready()->void:
	failure_panel.hide()
	success_panel.hide()
	order_manager.order_failed.connect(spawn_failed_order)
	set_random_timer()
	_clear_failed_orders()

func set_random_timer()->void:
	timer.start(randf_range(3,8))

func spawn_new_npc()->void:
	if !GameLevel.current.game_is_running:
		return
	cached_npc = await npc_manager.spawn_customer()
	cached_npc.set_destination(interaction_spot.global_position)
	cached_npc.npc_reached_destination.connect(set_customer_order)

func set_customer_order()->void:
	var order = cached_npc.get_customer_order()
	order_manager.set_new_order(order)
	

func _clear_failed_orders()->void:
	for i in failed_order_container.get_children():
		i.queue_free()



func customer_left_map()->void:
	set_random_timer()
	cached_npc.queue_free()
	

func can_interact()->bool:
	if !_can_interact:
		return false
	if order_manager.current_order !=null and Player.instance._has_item():
		return true
	return false

func _do_interaction_internal()->void:
	_can_interact = false
	var success = order_manager.try_submit_order(Player.instance.item_holder.get_item())
	get_tree().create_timer(0.5).timeout.connect(_on_time_out)
	if success:
		GameManager.ui_manager.ui_audio.play_file(on_success_audio_Stream)
		success_panel.show()
	else:
		GameManager.ui_manager.ui_audio.play_file(on_failure_audio_Stream)
		failure_panel.show()
	Player.instance.item_holder.clear_held_item()
	if cached_npc:
		cached_npc.npc_reached_destination.disconnect(set_customer_order)
		cached_npc.npc_reached_destination.connect(customer_left_map)
		cached_npc.set_destination(npc_manager.get_random_map_edge())
	else:
		set_random_timer()


func spawn_failed_order(dict:Dictionary[ItemData,int])->void:
	_clear_failed_orders()
	for i in dict:
		var amount = dict[i]
		for k in range(amount):
			var part = FAILED_ORDER_PART_UI.instantiate()
			failed_order_container.add_child(part)
			part.set_item(i)

func _on_interaction_end()->void:
	order_manager.end_current_order()
	

func _on_time_out()->void:
	_can_interact = true
	failure_panel.hide()
	success_panel.hide()
	_clear_failed_orders()
	set_random_timer()
