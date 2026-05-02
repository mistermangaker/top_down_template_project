class_name  DynamicUIManager extends Control



var current_menu:BaseCloseableUI

func add_new(menu:PackedScene, override_id:String = "")->BaseCloseableUI:
	var new_instance = menu.instantiate() as BaseCloseableUI
	current_menu = new_instance
	add_child(new_instance)
	return new_instance

func set_menu(menu:PackedScene, override_id:String = "")->BaseCloseableUI:
	if menu == null:
		printerr("hey dummy you forgot to set up this menu with id: %s fix this!"%override_id)
		print_stack()
		return
	var new_instance = menu.instantiate() as BaseCloseableUI
	if new_instance:
		
		if current_menu:
			_force_close_current_menu()
		if override_id !="":
			new_instance.unique_ID = override_id
		add_child(new_instance)
		current_menu = new_instance
		current_menu.close_requested.connect(_force_close_current_menu)
		current_menu.on_open()
	return new_instance

func check():
	pass

func clear_menu(id:String)->void:
	if !current_menu:
		return
	elif current_menu.unique_ID == id:
		_force_close_current_menu()

func _force_close_current_menu()->void:
	current_menu.menu_closing.emit()
	current_menu.on_close()
	current_menu.queue_free()
