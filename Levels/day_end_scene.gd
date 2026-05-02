extends CanvasLayer
@onready var day_label: Label = %DayLabel
@onready var orders_completed_label: Label = %OrdersCompletedLabel
@onready var next_day_button: Button = %NextDayButton
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var happy_music: AudioStreamPlayer = $HappyMusic
@onready var un_happy_music: AudioStreamPlayer = $UnHappyMusic
@onready var v_box_container: VBoxContainer = %VBoxContainer
@export var debug:bool
var day_passed:bool

func _ready() -> void:
	var day = GameManager.systems.game_data.day_number
	var required = GameManager.systems.game_data.todays_required_orders
	var completed = GameManager.systems.game_data.todays_successful_orders
	day_passed = completed >= required
	day_label.text = tr("UI_DAY_NUMBER")+" "+str(day)
	orders_completed_label.text = tr("DAYEND_ORDERS_COMPLETED_LABEL") +" "+str(completed)+"/"+str(required)
	if day_passed:
		happy_music.play()
		next_day_button.text = tr("SUCCESS_LABEL")
	else:
		if debug:
			var button = Button.new()
			button.text = "continue"
			v_box_container.add_child(button)
			button.pressed.connect(go_to_next_day)
		un_happy_music.play()
		next_day_button.text = tr("FAILURE_LABEL")
	

func go_to_next_day()->void:
	GameManager.systems.game_data.incriment_day()
	GameManager.scene_manager.transition_to_scene("res://Levels/main_game_scene.tscn","fade_to_black")

func _on_next_day_button_pressed() -> void:
	if day_passed:
		go_to_next_day()
	else:
		GameManager.quit_to_main_menu()
