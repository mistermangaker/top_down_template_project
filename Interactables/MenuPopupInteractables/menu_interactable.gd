class_name MenuInteractableObject extends InteractableObject

@export var menu_scene:PackedScene
@onready var area_2d: Area2D = $Area2D
var loaded_menu:BaseCloseableUI

func on_interactable_ready()->void:
	area_2d.body_exited.connect(_on_area_2d_body_exited)

func _do_interaction_internal()->void:
	if loaded_menu:
		GameManager.ui_manager.close_request_for_dynamic_menu(loaded_menu.unique_ID)
	else:
		loaded_menu = GameManager.ui_manager.spawn_in_dynamic_ui(menu_scene,"test_label")
		post_spawn_in()

func post_spawn_in()->void:
	pass

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		if loaded_menu!=null:
			loaded_menu.close_self()
