extends HBoxContainer
@onready var settings_button: OptionButton = $SettingsButton
@onready var option_setting_label: Label = $OptionSettingLabel
@export var display_name:String = ""


func _ready() -> void:
	if display_name!="":
		option_setting_label.text = display_name
	settings_button.item_selected.connect(index_seclected)
	for i in SystemSettings.WINDOW_MODE_ARRAY:
		settings_button.add_item(i)
	settings_button.select(SystemSettings.get_window_mode_index())

func index_seclected(index:int)->void:
	SystemSettings.set_window_mode_index(index)
	
