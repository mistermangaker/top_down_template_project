extends MenuInteractableObject

@export var sign_header_text:String
@export var sign_body_text:String 


func post_spawn_in()->void:
	loaded_menu.set_text(sign_header_text,sign_body_text)
