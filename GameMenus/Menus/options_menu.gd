extends Control

signal close_requested

func _on_close_button_pressed() -> void:
	close_requested.emit()
