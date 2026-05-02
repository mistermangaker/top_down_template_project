extends ItemHolderInteractable


@onready var texture_progress_bar: TextureProgressBar = %TextureProgressBar
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var base_sprite: AnimatedSprite2D = $BaseSprite

@export var cooking_recipies:Array[CookingRecipe]
@export var burning_recipies:Array[CookingRecipe]
@onready var grill_sizzling: AudioStreamPlayer2D = $GrillSizzling
@onready var audio_alert: AudioStreamPlayer2D = %AudioAlert

enum InteractableState{
	None,
	Cooking,
	Burning
}

var state:InteractableState

var cooking_timer:float

var current_recipe:CookingRecipe

func _do_interaction_internal()->void:
	
	var player_item =Player.instance.item_holder.get_item()
	var this_item =item_holder.get_item() 
	if this_item == null and player_item is ItemPlate:
		var new_item = player_item.get_and_remove_last_item()
		item_holder.set_held_item(new_item)
		return
	super._do_interaction_internal()

func on_interactable_start()->void:
	texture_progress_bar.hide()

func can_interact()->bool:
	var player_item =Player.instance.item_holder.get_item()
	if player_item is ItemPlate:
		if _has_item():
			return true
		if get_cooking_recipe(player_item.get_last_item()) !=null or get_burning_recipe(player_item.get_last_item())!=null:
			return true
	elif  get_cooking_recipe(Player.instance.item_holder.get_item_data()) !=null or get_burning_recipe(Player.instance.item_holder.get_item_data())!=null:
		return true
	
	return _has_item()

func should_be_visible()->bool:
	return Player.instance._has_item() or _has_item()

func get_burning_recipe(item:ItemData)->CookingRecipe:
	for i in burning_recipies:
		if i.input_Item ==item:
			return i
	return null

func get_cooking_recipe(item:ItemData)->CookingRecipe:
	for i in cooking_recipies:
		if i.input_Item ==item:
			return i
	return null

func _physics_process(delta: float) -> void:
	match state:
		InteractableState.None:
			return
		InteractableState.Cooking:
			_cook_item(delta)
		InteractableState.Burning:
			_burn_item(delta)


func _burn_item(delta:float)->void:
	cooking_timer +=delta
	var time = _get_time_normalized()
	texture_progress_bar.value = time*100
	if time>0.5:
		animation_player.play("flashing")
		if !audio_alert.playing:
			audio_alert.play()
		audio_alert.volume_db = time*2
	if cooking_timer >= current_recipe.cook_time:
		item_holder.get_item().delete_self()
		var item = GameItem.create_item(current_recipe.output_item)
		item_holder.set_held_item(item)
		cooking_timer = 0
		animation_player.play("RESET")
		audio_alert.stop()
		grill_sizzling.stop()
		texture_progress_bar.visible = false
		state = InteractableState.None
		

func _get_time_normalized()->float:
	return cooking_timer / current_recipe.cook_time

func _cook_item(delta:float)->void:
	cooking_timer +=delta
	var time = _get_time_normalized()
	
	texture_progress_bar.value = time*100
	if cooking_timer >= current_recipe.cook_time:
		item_holder.get_item().delete_self()
		var item = GameItem.create_item(current_recipe.output_item)
		item_holder.set_held_item(item)
		decide_next_step()
		

func decide_next_step()->void:
	cooking_timer = 0
	var item_data = item_holder.get_item_data()
	var next_step = get_cooking_recipe(item_data)
	audio_alert.stop()
	if next_step !=null:
		current_recipe = next_step
		state = InteractableState.Cooking
		texture_progress_bar.visible = true
		base_sprite.play("cooking")
		grill_sizzling.play()
	else:
		next_step = get_burning_recipe(item_data)
		if next_step !=null:
			current_recipe = next_step
			state = InteractableState.Burning
			texture_progress_bar.visible = true
			base_sprite.play("cooking")
			if !grill_sizzling.playing:
				grill_sizzling.play()
		else:
			current_recipe = null
			state = InteractableState.None
			animation_player.play("RESET")
			base_sprite.play("default")
			texture_progress_bar.visible = false
			grill_sizzling.stop()
			

func _on_interaction_end()->void:
	if _has_item():
		decide_next_step()
		#state = InteractableState.Cooking
		#current_recipe = get_cooking_recipe(item_holder.get_item_data())
	else:
		state = InteractableState.None
		animation_player.play("RESET")
		base_sprite.play("default")
		texture_progress_bar.visible = false
		grill_sizzling.stop()
		audio_alert.stop()
