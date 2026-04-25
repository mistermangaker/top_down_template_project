extends HBoxContainer
@onready var settings_button: OptionButton = $SettingsButton

func _ready() -> void:
	settings_button.item_selected.connect(index_seclected)
	for i in SystemSettings.WINDOW_MODE_ARRAY:
		settings_button.add_item(i)
	settings_button.select(SystemSettings.get_window_mode_index())

func index_seclected(index:int)->void:
	SystemSettings.set_window_mode_index(index)
	
