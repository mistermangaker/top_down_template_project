class_name ItemViusals extends Node2D

const item_offset = -4

var stack_top:float

func add_visuals(texture_2d:Texture2D)->void:
	var sprite = Sprite2D.new()
	add_child(sprite)
	sprite.texture = texture_2d
	sprite.offset = Vector2(0,stack_top)
	stack_top += item_offset

func remove_top_visual()->void:
	stack_top-=item_offset
	get_child(-1).queue_free()

func clear_visuals()->void:
	for i in get_children():
		i.queue_free()
	stack_top = 0
