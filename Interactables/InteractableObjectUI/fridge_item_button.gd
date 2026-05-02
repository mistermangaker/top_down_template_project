extends HBoxContainer

signal item_pressed(data:ItemData)

@onready var item_icon: Button = $ItemIcon
@onready var label: Label = $Label



var item_data:ItemData
func set_item(_item_data:ItemData)->void:
	item_icon.icon = _item_data.texture
	label.text = _item_data.display_name
	item_data = _item_data



func _on_item_icon_pressed() -> void:
	item_pressed.emit(item_data)
