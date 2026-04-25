class_name Door extends Area2D

signal player_entered_door(door:Door,transition_id:String)
@onready var door_sprite: Sprite2D = $DoorSprite

@export_enum("north","east","south","west") var entery_direction:int
@export_enum("fade_to_black") var transition_type:String="fade_to_black"

@export var closed_texture:Texture2D
@export var open_texture:Texture2D

@export var path_to_new_scene:String
@export var entry_door_name:String
@export var door_size:float = 32
var disable = false

func _ready() -> void:
	door_sprite.texture = closed_texture

func _on_body_entered(body: Node2D) -> void:
	if not body is Player or disable==true:
		return
	door_sprite.texture = open_texture
	player_entered_door.emit(self,transition_type)
	disable=true
	get_tree().create_timer(0.05).timeout.connect(disable_player)

func disable_player()->void:
	Player.instance.disable()

func get_movement_dir():
	match entery_direction:
		0:
			return EntityVisuals.FacingDirection.south
		1:
			return EntityVisuals.FacingDirection.west
		2:
			return EntityVisuals.FacingDirection.north
		3:
			return EntityVisuals.FacingDirection.east


func get_player_entry_vector():
	match entery_direction:
		0: #south
			return Vector2(0,door_size) +global_position
		1: #west
			return Vector2(-door_size,0) +global_position
		2: #north
			return Vector2(0,-door_size) +global_position
		3: #east
			return Vector2(door_size,0) +global_position
