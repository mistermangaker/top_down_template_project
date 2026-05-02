class_name Entity extends CharacterBody2D
@export var agent_visuals: EntityVisuals
@export var entity_move_speed:float = 100


@onready var state_machine: StateMachine = $StateMachine
@onready var item_holder: ItemHolder = $ItemHolder
@onready var held_items_visual: ItemViusals = $HeldItemsVisual


func _ready() -> void:
	item_holder.item_changed.connect(_item_equipped)
	item_holder.item_added_to_plate.connect(_item_added)
	item_holder.plate_cleared.connect(_clear_all_items)
	item_holder.top_viusal_removed.connect(_remove_top_visual)


const EMPTY_TEXTURE = preload("uid://clqnccnfdryxa")

func _remove_top_visual()->void:
	held_items_visual.remove_top_visual()

func _clear_all_items()->void:
	const PLATE = preload("uid://cldr4vm0vldso")
	held_items_visual.clear_visuals()
	held_items_visual.add_visuals(PLATE)

func _item_added(data:ItemData)->void:
	if data==null:
		return
	held_items_visual.add_visuals(data.texture)

func _item_equipped(item:GameItem)->void:
	if item==null:
		agent_visuals.clear_carry_sprite()
		held_items_visual.clear_visuals()
		return
	agent_visuals.set_carry_sprite(EMPTY_TEXTURE,Vector2.ONE,Vector2(0,-13))
	held_items_visual.add_visuals(item.data.texture)
	if item is ItemPlate:
		for i:ItemData in item.held_items:
			held_items_visual.add_visuals(i.texture)


func orient(dir:EntityVisuals.FacingDirection)->void:
	agent_visuals.facing_direction = dir

func enable()->void:
	state_machine.call_deferred("transition_to","enabled")
	

func disable()->void:
	state_machine.call_deferred("transition_to","disabled")
	
func is_moving()->bool:
	return agent_visuals.is_moving

func get_facing_direction()->EntityVisuals.FacingDirection:
	return agent_visuals.facing_direction
