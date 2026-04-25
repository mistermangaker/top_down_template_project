extends Control


func _on_quit_button_pressed() -> void:
	GameManager.quit_to_main_menu()


func _on_options_button_pressed() -> void:
	GameManager.ui_manager.show_options_menu()


func _on_continue_button_pressed() -> void:
	GameManager.unpause_game()
