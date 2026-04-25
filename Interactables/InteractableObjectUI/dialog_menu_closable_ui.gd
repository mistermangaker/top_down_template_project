extends BaseCloseableUI
var lines:Array[String]=[]
var index =0
const tag = "[line]"
@onready var header: RichTextLabel = %Header



func set_text(text:String)->void:
	var split = text.split(tag)
	for i in split:
		lines.append(i.trim_prefix(tag))
	show_dialog_line(0)
	
func show_dialog_line(next_index:int)->void:
	if lines.size()<=next_index:
		
		close_self()
	else:
		var dialog_line = lines[next_index]
		header.text = dialog_line

func _on_button_pressed() -> void:
	index +=1
	show_dialog_line(index)
	
