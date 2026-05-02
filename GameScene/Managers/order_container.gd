extends VBoxContainer

@onready var required_items: HBoxContainer = %RequiredItems
@onready var forbidden_items: HBoxContainer = %ForbiddenItems

func set_up(this_order:CustomerOrder)->void:
	if !this_order.required_items.is_empty():
		var label = Label.new()
		label.text = tr("UI_REQUIRED")+":"
		required_items.add_child(label)
	
	for required:ItemData in this_order.required_items:
		var num:int = this_order.required_items[required]
		
		for i in range(num):
			var required_text = "%s: %s"%[tr("UI_REQUIRED"),required.get_display_name()]
			var tex_rect = TextureRect.new()
			tex_rect.custom_minimum_size = Vector2(32,32)
			
			tex_rect.tooltip_text = required_text
			tex_rect.texture = required.texture
			required_items.add_child(tex_rect)
	
