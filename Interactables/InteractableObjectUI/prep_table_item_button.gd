extends Control

signal item_pressed(data:ItemData)

@onready var item_button: Button = %ItemButton
@onready var required_items: HBoxContainer = %RequiredItems
@onready var forbidden_items: HBoxContainer = %ForbiddenItems

var this_recipe:CraftingRecipe

func set_up(crafting_recipe:CraftingRecipe)->void:
	this_recipe = crafting_recipe
	item_button.icon = crafting_recipe.output_item.texture
	item_button.tooltip_text = "%s: %s"%[tr("UI_MAKE_ITEM"),crafting_recipe.output_item.get_display_name()]
	
	if !crafting_recipe.required_items.is_empty():
		var label = Label.new()
		label.text = tr("UI_REQUIRED")
		required_items.add_child(label)
	
	for required:ItemData in crafting_recipe.required_items:
		var num:int = crafting_recipe.required_items[required]
		
		for i in range(num):
			var required_text = "%s: %s"%[tr("UI_REQUIRED"),required.get_display_name()]
			var tex_rect = TextureRect.new()
			tex_rect.custom_minimum_size = Vector2(32,32)
			
			tex_rect.tooltip_text = required_text
			tex_rect.texture = required.texture
			required_items.add_child(tex_rect)
	
	if not this_recipe.is_valid(Player.instance.item_holder.get_item()):
		item_button.disabled = true
	

func _on_item_button_pressed() -> void:
	item_pressed.emit(this_recipe.output_item)
