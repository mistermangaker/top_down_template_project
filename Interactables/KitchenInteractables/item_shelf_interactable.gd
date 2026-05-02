class_name ItemHolderInteractable extends InteractableObject
@onready var item_sprite: Sprite2D = %ItemSprite
@onready var item_holder: ItemHolder = %ItemHolder
@onready var held_items_visual: ItemViusals = %HeldItemsVisual
@onready var pick_up_audio: AudioStreamPlayer = $PickUpAudio
@onready var put_down_audio: AudioStreamPlayer = $PutDownAudio





func on_interactable_ready()->void:
	item_holder.item_changed.connect(_new_item_set)
	item_holder.item_added_to_plate.connect(_new_item_added)
	item_holder.plate_cleared.connect(clear_all_items)
	item_holder.top_viusal_removed.connect(_remove_top_visual)
	const JD_SHERBERT___PIXEL_UI_SFX_PACK___CURSOR_3__SAW_ = preload("uid://ghnyajirmddr")
	const JD_SHERBERT___PIXEL_UI_SFX_PACK___CURSOR_3__SQUARE_ = preload("uid://giknlwi5htqq")
	pick_up_audio.stream = JD_SHERBERT___PIXEL_UI_SFX_PACK___CURSOR_3__SQUARE_
	
	put_down_audio.stream = JD_SHERBERT___PIXEL_UI_SFX_PACK___CURSOR_3__SAW_
	pick_up_audio.bus = &"SFX"
	put_down_audio.bus = &"SFX"

func play_pick_up_audio()->void:
	pick_up_audio.play()

func play_put_down_audio()->void:
	put_down_audio.play()

func _remove_top_visual()->void:
	held_items_visual.remove_top_visual()

func clear_all_items()->void:
	const PLATE = preload("uid://cldr4vm0vldso")
	held_items_visual.clear_visuals()
	held_items_visual.add_visuals(PLATE)

func _new_item_added(data:ItemData)->void:
	if data==null:
		return
	held_items_visual.add_visuals(data.texture)

func _new_item_set(item:GameItem)->void:
	if item==null:
		
		held_items_visual.clear_visuals()
		return
	
	held_items_visual.add_visuals(item.data.texture)
	if item is ItemPlate:
		for i:ItemData in item.held_items:
			held_items_visual.add_visuals(i.texture)



func should_be_visible()->bool:
	
	return Player.instance._has_item() or _has_item()

func can_interact()->bool:
	if !Player.instance._has_item() and !_has_item():
		
		return false
	return true

func _has_item()->bool:
	return item_holder.held_item !=null

func reset_text()->void:
	Player.instance.reset_interactable_text()

func _do_interaction_internal()->void:
	var player_item =Player.instance.item_holder.get_item()
	var this_item =item_holder.get_item()
	var player_is_plate = player_item is ItemPlate
	var this_is_plate  = this_item is ItemPlate
	
	if this_item!=null and player_item!=null:
		
		if player_is_plate and this_is_plate:
			if player_item.plate_is_empty():
				play_pick_up_audio()
				item_holder.clear_held_item()
				item_holder.set_held_item(player_item)
				Player.instance.item_holder.clear_held_item()
				Player.instance.item_holder.set_held_item(this_item)
			else:
				play_put_down_audio()
				
				this_item.add_item(player_item)
			
		elif not this_is_plate and player_is_plate:
			play_put_down_audio()
			
			player_item.add_item(this_item)
			play_pick_up_audio()
		elif this_is_plate and not player_is_plate:
			play_put_down_audio()
			
			this_item.add_item(player_item)
		else:
			play_pick_up_audio()
			item_holder.clear_held_item()
			item_holder.set_held_item(player_item)
			Player.instance.item_holder.clear_held_item()
			Player.instance.item_holder.set_held_item(this_item)
		reset_text()
	elif this_item!=null and player_item==null:
		play_pick_up_audio()
		Player.instance.item_holder.set_held_item(this_item)
		item_holder.clear_held_item()
		reset_text()
		
	elif this_item==null and player_item!=null:
		play_put_down_audio()
		var item =Player.instance.item_holder.get_item()
		item_holder.set_held_item(item)
		Player.instance.item_holder.clear_held_item()
		reset_text()

func get_interactable_text()->String:
	if !can_interact():
		return _get_can_not_do_interaction_text()
	var interaction_start = tr("PRESS_TO_INTERACT_START")
	interaction_start = interaction_start.format({"button":_get_interact_key_string()})
	if Player.instance._has_item() and _has_item():
		
		var player_item =Player.instance.item_holder.get_item_text()
		var this_item =item_holder.get_item_text()
		
		if Player.instance.item_holder.get_item() is ItemPlate and not item_holder.get_item() is ItemPlate:
			var place_item_in_plate = tr("INTERACT_PLACE_ON_PLATE")
			place_item_in_plate = place_item_in_plate.format({"food_item":this_item,"this_item":player_item })
			return interaction_start+" "+place_item_in_plate
			#return "press: %s to add %s to %s"  % [_get_interact_key_string(),this_item,player_item]
		elif item_holder.get_item() is ItemPlate and not Player.instance.item_holder.get_item():
			var place_item_in_plate = tr("INTERACT_PLACE_ON_PLATE")
			place_item_in_plate = place_item_in_plate.format({"food_item":player_item,"this_item":this_item})
			return interaction_start+" "+place_item_in_plate
		elif Player.instance.item_holder.get_item() is ItemPlate:
			var plate_item =  Player.instance.item_holder.get_item() as ItemPlate
			if !plate_item.held_items.is_empty():
				var data:ItemData = plate_item.held_items[plate_item.held_items.size()-1]
				var place_item_in_plate = tr("INTERACT_PLACE_ON_PLATE")
				var display_name = data.get_display_name()
				
				place_item_in_plate = place_item_in_plate.format({"food_item":display_name ,"this_item":this_item})
				return interaction_start+" "+place_item_in_plate
		
		
		var swap_text =tr("INTERACT_SWAP")
		swap_text = swap_text.format({"food_item":this_item ,"this_item":player_item})
		return interaction_start+" "+swap_text 
		#return "press: %s to swap %s"  % [_get_interact_key_string(),item_holder.get_item_text()]
	if _has_item():
		var pick_up_text = tr("INTERACT_PICK_UP")
		return interaction_start+" "+pick_up_text 
		#return "press: %s to pick up %s"  % [_get_interact_key_string(),item_holder.get_item_text()]
	else:
		var set_down_text = tr("INTERACT_SET_DOWN")
		return interaction_start+" "+set_down_text 
		#return "press: %s to set down %s"  % [_get_interact_key_string(),Player.instance.item_holder.get_item_text()]
	
