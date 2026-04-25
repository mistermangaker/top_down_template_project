extends HBoxContainer
@onready var audio_setting_label: Label = %AudioSettingLabel
@onready var percentage_slider: HSlider = %PercentageSlider
@onready var percentage_label: Label = %PercentageLabel

@export_enum("Master","Music","SFX") var bus_name:String

var bus_index:int = 0

func _ready() -> void:
	percentage_slider.value_changed.connect(slider_value_changed)
	set_bus_index_by_name()
	set_slider_value()
	set_audio_num_label_text()
	set_name_label_text()
	

func set_name_label_text()->void:
	audio_setting_label.text = str(bus_name)+" Volume"

func set_audio_num_label_text()->void:
	percentage_label.text = str(percentage_slider.value*100)+"%"

func set_slider_value()->void:
	var value = 0
	match bus_index:
		0:
			
			value = SystemSettings.get_master_volume()
		1:
			
			value = SystemSettings.get_music_volume()
		2:
			
			value = SystemSettings.get_sfx_volume()
	
	percentage_slider.value = value

func set_bus_index_by_name()->void:
	bus_index = AudioServer.get_bus_index(bus_name)

func slider_value_changed(new_value:float)->void:
	#AudioServer.set_bus_volume_db(bus_index,linear_to_db(new_value))
	match bus_index:
		0:
			SystemSettings.set_master_volume(new_value)
		1:
			SystemSettings.set_music_volume(new_value)
		2:
			SystemSettings.set_sfx_volume(new_value)
	set_audio_num_label_text()





	
