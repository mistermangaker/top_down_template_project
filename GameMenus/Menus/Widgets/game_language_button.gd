extends HBoxContainer
@onready var option_setting_label: Label = $OptionSettingLabel
@onready var settings_button: OptionButton = $SettingsButton
@export var display_name:String = ""


func _ready() -> void:
	if display_name!="":
		option_setting_label.text = display_name
	set_up_languages()
	settings_button.item_selected.connect(index_seclected)
	

func set_up_languages()->void:
	settings_button.add_item("GRAPHIC_GAME_LANGUAGE_EN_NAME")
	settings_button.add_item("GRAPHIC_GAME_LANGUAGE_ES_NAME")
	settings_button.selected = SystemSettings.get_language_index()


func index_seclected(index:int)->void:
	SystemSettings.set_language_index(index)
