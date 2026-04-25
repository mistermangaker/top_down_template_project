extends CanvasLayer

signal scene_transition_callback

@onready var color_rect: ColorRect = $ColorRect
@onready var label: Label = %Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@warning_ignore("unused_parameter")
func make_transition(transition_id:String, level_text:String = "")->void:
	label.text = level_text
	animation_player.play(transition_id)
	await get_tree().create_timer(0.3).timeout
	_load_new_scene()

func _load_new_scene()->void:
	scene_transition_callback.emit()
