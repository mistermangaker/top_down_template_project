class_name BaseCloseableUI extends Control

@export var unique_ID:String
signal close_requested

@warning_ignore("unused_signal")
signal menu_closing
func on_open()->void:
	pass



func on_close()->void:
	pass

func close_self()->void:
	close_requested.emit()
