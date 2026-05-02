class_name MenuInteractableObject extends InteractableObject

@export var menu_scene:PackedScene
@onready var area_2d: Area2D = $Area2D
@onready var popup_open_audio: AudioStreamPlayer2D = %PopupOpenAudio
@onready var popup_close_audio: AudioStreamPlayer2D = %PopupCloseAudio

@export var on_open_audio_stream:AudioStream
@export var on_close_audio_Stream:AudioStream
var loaded_menu:BaseCloseableUI

func on_interactable_ready()->void:
	area_2d.body_exited.connect(_on_area_2d_body_exited)
	if on_open_audio_stream:
		popup_open_audio.stream = on_open_audio_stream
	if on_close_audio_Stream:
		popup_close_audio.stream = on_close_audio_Stream

func _do_interaction_internal()->void:
	if loaded_menu:
		GameManager.ui_manager.close_request_for_dynamic_menu(loaded_menu.unique_ID)
	else:
		loaded_menu = GameManager.ui_manager.spawn_in_dynamic_ui(menu_scene,"test_label")
		loaded_menu.menu_closing.connect(post_menu_close)
		loaded_menu.menu_closing.connect(play_close_audio)
		post_spawn_in()
		play_open_audio()

func play_open_audio()->void:
	popup_open_audio.play()

func play_close_audio()->void:
	popup_close_audio.play()

func post_spawn_in()->void:
	pass

func post_menu_close()->void:
	pass

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		if loaded_menu!=null:
			loaded_menu.close_self()
