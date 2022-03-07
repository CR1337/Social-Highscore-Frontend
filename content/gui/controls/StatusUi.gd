extends Node2D

onready var shopping_sprite = $ShoppingSprite
onready var timer_label = $TimerLabel
onready var status_sprite = $StatusSprite
onready var weekday_label = $WeekdayLabel
onready var sleep_sprite = $SleepSprite

const _weekdays = [
	"Saturday",
	"Sunday",
	"Monday",
	"Tuesday",
	"Wednesday",
	"Thursday",
	"Friday"
]

func _process(delta):
	shopping_sprite.visible = len(GameStateController.shopping_cart) > 0
	if GameStateController.at_work:
		_display_work()
	else:
		_display_hunger()
	_display_weekday()
	_display_sleep()
		
func _display_work():
	status_sprite.animation = 'work'
	_display_timer(TimeController.get_remaining_seconds(
		GameStateController.work_timer_handle
	))
	status_sprite.visible = true
	timer_label.visible = true
	
func _display_hunger():
	var hunger = int(GameStateController.hunger)
	match hunger:
		-1:
			status_sprite.visible = false
			timer_label.visible = false
		0:
			status_sprite.visible = false
			timer_label.visible = false
		1:
			status_sprite.animation = 'hungry'
			status_sprite.visible = true
			timer_label.visible = false
		2:
			status_sprite.animation = 'very_hungry'
			_display_timer(TimeController.get_remaining_seconds(
				GameStateController.hunger_timer_handle
			))
			status_sprite.visible = true
			timer_label.visible = true
	
func _display_timer(total_seconds):
	var minutes = floor(total_seconds / 60)
	var seconds = total_seconds - (minutes * 60)
	
	var minutes_string = "%02d" % minutes
	var seconds_string = "%02d" % seconds

	timer_label.text = minutes_string + ":" + seconds_string
	
func _display_weekday():
	var weekday_index = int(GameStateController.current_day) % 7
	weekday_label.text = _weekdays[weekday_index]
	
func _display_sleep():
	var current_story_controller = GameStateController.current_story_controller()
	sleep_sprite.visible = current_story_controller.states[current_story_controller.progress] == 'goto_bed'
