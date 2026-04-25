extends Control

const GAME_SCENE = preload("uid://nvydwcpyo0vj")
@onready var game_options: Control = $GameOptions

func _ready() -> void:
	game_options.hide()
	game_options.close_requested.connect(game_options.hide)

func _on_start_game_button_pressed() -> void:
	get_tree().change_scene_to_packed(GAME_SCENE)


func _on_options_button_pressed() -> void:
	game_options.show()


func _on_quit_game_button_pressed() -> void:
	pass # Replace with function body.
