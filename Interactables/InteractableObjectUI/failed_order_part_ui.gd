extends HBoxContainer
@export var texture_rect: TextureRect 
@export var label: Label 

func set_item(item:ItemData)->void:
	texture_rect.texture = item.texture
	label.text = item.get_display_name()
