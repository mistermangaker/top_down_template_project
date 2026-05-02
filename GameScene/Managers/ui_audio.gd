class_name UIAudioManager extends Node
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func play_file(audio_file:AudioStream)->void:
	audio_stream_player.stream = audio_file
	audio_stream_player.play()
