class_name EntityVisuals extends Node2D

@export var animated_sprite_2d: AnimatedSprite2D
@export var carry_sprite: Sprite2D

enum FacingDirection{
	south=0,
	north=1,
	east=2,
	west=3
}

var movement_dir:Vector2

var previous_position:Vector2

var is_moving:bool:
	set(value):
		if value ==is_moving:
			return
		
		is_moving = value
		update_animation()

var facing_direction:FacingDirection:
	set(value):
		if value == facing_direction:
			return
		
		facing_direction = value
		update_animation()

var current_animation:String = "idle"

var current_facing_direction_for_ref:String = "south"

#region facingDirection
func set_facing_direction(direction:FacingDirection)->void:
	facing_direction = direction

func get_vector_of_facing_direction()->Vector2:
	match facing_direction:
		FacingDirection.south:
			return Vector2.DOWN
		FacingDirection.north:
			return Vector2.UP
		FacingDirection.east:
			return Vector2.RIGHT
		FacingDirection.south:
			return Vector2.LEFT
	return Vector2.ZERO


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	#(global_position -previous_position).normalized()
	var player = get_parent() as Player
	movement_dir = player.velocity.normalized()
	
	if player.velocity!= Vector2.ZERO:
		is_moving = true
	else:
		is_moving = false
	previous_position = global_position

func is_moving_east()->bool:
	return movement_dir.x >0

func is_moving_west()->bool:
	return movement_dir.x <0

func is_moving_north()->bool:
	return movement_dir.y <0

func is_moving_south()->bool:
	return movement_dir.y >= 0

func get_vertical_movement_direction()->FacingDirection:
	if is_moving_north():
		return FacingDirection.north
	else:
		return FacingDirection.south

func get_horizontal_movement_direction()->FacingDirection:
	if is_moving_east():
		return FacingDirection.east
	else:
		return FacingDirection.west

func is_agent_mov_x_larger_than_move_y()->bool:
	return absf(movement_dir.x)  > absf(movement_dir.y)

func get_over_all_move_dir()->Vector2i:
	var x:int = abs_int(movement_dir.x)
	var y:int = abs_int(movement_dir.y)
	return Vector2i(x,y)

static func abs_int(num:float)->int:
	if num > 0:
		return 1
	if num <0:
		return -1
	return 0

func update_facing_direction_4_way()->void:
	var movedir = get_over_all_move_dir()
	var dir_x:FacingDirection =get_horizontal_movement_direction()
	var dir_y:FacingDirection = get_vertical_movement_direction()
	if movedir.x != 0 && movedir.y !=0:
		if is_agent_mov_x_larger_than_move_y():
			facing_direction = dir_x
		else:
			facing_direction = dir_y
	elif movedir.x !=0:
		facing_direction = dir_x
	elif movedir.y!=0:
		facing_direction = dir_y

func update_facing_direction_horizontal_only()->void:
	var movedir = get_over_all_move_dir()
	if movedir.x ==0:
		return
	facing_direction=get_horizontal_movement_direction()

#endregion

#region animation
func set_sprite_frames(sprite_frame:SpriteFrames)->void:
	animated_sprite_2d.sprite_frames = sprite_frame


func play_animation(anim:String)->void:
	if anim == current_animation:
		return
	current_animation = anim
	update_animation()


func stop_animation()->void:
	animated_sprite_2d.stop()



func play_emote_one_way(anim:String,callback:Callable,loop_time:float=0)->bool:
	if animated_sprite_2d.sprite_frames.has_animation(anim):
		play_one_shot(anim,callback,loop_time)
		return true
	return false

func play_one_shot(anim:String,callback:Callable,loop_time:float=0)->void:
	if loop_time >0:
		animated_sprite_2d.play(anim)
		await get_tree().create_timer(loop_time).timeout
		stop_animation()
		callback.call()
	else:
		animated_sprite_2d.play(anim)
		await animated_sprite_2d.animation_looped
		stop_animation()
		callback.call()

func set_carry_sprite(texture:Texture2D,tex_scale:Vector2=Vector2.ONE,offset:Vector2=Vector2(0,-30))->void:
	carry_sprite.texture = texture
	carry_sprite.scale = tex_scale
	carry_sprite.offset = offset

func clear_carry_sprite()->void:
	carry_sprite.texture = null
	carry_sprite.scale = Vector2.ONE
	carry_sprite.offset = Vector2()



static func get_facing_dir_for(dir:FacingDirection)->String:
	match dir:
		FacingDirection.west:
			return "west"
		FacingDirection.east:
			return "east"
		FacingDirection.north:
			return "north"
		_:
			return "south"

func update_animation():
	
	current_facing_direction_for_ref = get_facing_dir_for(facing_direction)
	if is_carryable_animation():
		var carry:String
		var move:String 
		if is_moving:
			move = WALK_ANIM
		else :
			move = IDLE_ANIM
		
		if carry_sprite.texture != null:
			carry = "carry"
		else:
			carry = ""
		
		current_animation = carry+move
	
	animated_sprite_2d.play(current_animation+"_"+current_facing_direction_for_ref)

func is_animation_done()->bool:
	return !animated_sprite_2d.is_playing()

const WALK_ANIM = "walking"
const IDLE_ANIM = "idle"
const WALK_CARRY_ANIM ="carrywalk"
const IDLE_CARRY_ANIM = "carryidle"



func is_carryable_animation()->bool:
	var flag1 = current_animation == WALK_ANIM
	var flag2 = current_animation == IDLE_ANIM
	var flag3 = current_animation==WALK_CARRY_ANIM
	var flag4 = current_animation == IDLE_CARRY_ANIM
	return flag1 or flag2 or flag3 or flag4
	
#endregion
