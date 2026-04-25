extends BaseCloseableUI
@onready var header: RichTextLabel = %Header
@onready var body: RichTextLabel = %Body

func set_text(header_text:String,body_text:String)->void:
	header.text = header_text
	body.text = body_text

func _on_button_pressed() -> void:
	close_self()
