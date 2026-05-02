class_name NPC extends Entity


@onready var emotes: AnimatedSprite2D = $Emotes

@export var npcs_order:CustomerOrder 
@export var override_skin:SpriteFrames
@export var possible_customer_orders:Dictionary[BaseOrder,float]
@export var navigation_agent_2d: NavigationAgent2D
func _ready() -> void:
	super._ready()
	if override_skin:
		agent_visuals.set_sprite_frames(override_skin)

static var all_npcs:Array[NPC]=[]

func _enter_tree() -> void:
	all_npcs.append(self)

func _exit_tree() -> void:
	all_npcs.erase(self)

func has_no_custom_orders()->bool:
	return possible_customer_orders.is_empty()

func has_no_override_skin()->bool:
	return override_skin == null

var target_location:Vector2
@warning_ignore("unused_signal")
signal npc_reached_destination

func set_destination(target:Vector2)->void:
	if !GameLevel.current.game_is_running:
		return
	if !state_machine.is_initialized:
		await state_machine.initialized
	target_location = target
	state_machine.transition_to("enabled/move_to_location")


func get_customer_order()->CustomerOrder:
	if npcs_order !=null:
		return npcs_order
	var order = get_weighted_drop(possible_customer_orders)
	if order is CustomerOrder:
		return order
	elif order is CustomerOrderCategory:
		return order.generate_order()
	return null

func get_weighted_drop(dict:Dictionary)->Variant:
	var items = dict.keys()

	var weights = PackedFloat32Array(dict.values()) 
		
	var rng = RandomNumberGenerator.new()
	rng.randomize()
		
	var index = rng.rand_weighted(weights)
	return items[index]
