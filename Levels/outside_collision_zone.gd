extends Area2D
@onready var ambiance: AudioStreamPlayer = $Ambiance

var track_player:bool

var collider_hieght:float
@export var node:Node2D
func _ready() -> void:
	
	var col_size = $CollisionShape2D.shape.size
	collider_hieght = col_size.y
	node.hide()

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if track_player:
		node.modulate.a = get_distance_normalized()
		var volume = linear_to_db(get_distance_normalized())
		if is_nan(volume):
			volume =0
		ambiance.volume_db = volume

func get_distance_normalized()->float:
	var dist = global_position.y - Player.instance.global_position.y 
	var final = 1-( dist/collider_hieght) 
	if final>0.95:
		final = 1
	if final <=0:
		final = 0
	if is_nan(final):
		final =0
	return final


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		track_player = false
		node.hide()
		ambiance.stop()


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		track_player = true
		node.show()
		node.modulate.a = get_distance_normalized()
		ambiance.play()
