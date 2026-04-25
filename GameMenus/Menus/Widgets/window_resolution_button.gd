extends HBoxContainer
@onready var settings_button: OptionButton = $SettingsButton



func _ready() -> void:
	settings_button.item_selected.connect(on_resolution_changed)
	add_resolution_items()

func add_resolution_items()->void:
	for i in SystemSettings.RESOLUTION_DICTIONARY:
		settings_button.add_item(i)
	settings_button.select(SystemSettings.get_resolution_index())

func on_resolution_changed(index:int)->void:
	SystemSettings.set_window_mode_index(index)
	#DisplayServer.window_set_size(RESOLUTION_DICTIONARY.values()[index])
