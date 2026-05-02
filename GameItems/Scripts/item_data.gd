class_name ItemData extends Resource

@export var texture:Texture2D

@export var display_name:String

func get_display_name()->String:
	var items_stuff = display_name.split("_")
	var return_string = ""
	for i in items_stuff:
		var translated = tr(i)
		return_string+=translated+" "
	return return_string
