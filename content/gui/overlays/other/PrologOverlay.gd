extends Node2D

onready var _text_label = $Background/Margin/VBox/TextLabel
onready var _tutorial_texture_rect = $Background/Margin/VBox/TutorialTextureRect
onready var _yes_button = $Background/Margin/VBox/HBox/YesButton
onready var _no_button = $Background/Margin/VBox/HBox/NoButton

var _text_dict: Dictionary
const _text_dict_filename = "res://texts/prolog.json"

var _state = -1
var _states = [
	"start",
	"ask_tutorial",
	"tutorial_dpad",
	"tutorial_action",
	"tutorial_time",
	"tutorial_bars",
	"tutorial_smartphone",
	"tutorial_banking_app",
	"tutorial_messenger_app",
	"tutorial_citzen_app",
	"tutorial_news_app",
	"start_game",
	"finished"
]

func _ready():
	_load_text_dict()
	_next_state()

func _load_text_dict():
	var file = File.new()
	file.open(_text_dict_filename, file.READ)
	_text_dict = JSON.parse(
		file.get_as_text()
	).result
	file.close()

func _next_state():
	_state += 1
	_text_label.text = _text_dict[_states[_state]]
	match _states[_state]:
		"start":
			_yes_button.text = "Next"
			_tutorial_texture_rect.visible = false
			_no_button.visible = false
		"ask_tutorial":
			ViewportManager.change_to_refenreceImage()
			_yes_button.text = "Yes"
			_no_button.text = "No"
			_no_button.visible = true
		"tutorial_dpad":
			_yes_button.text = "Next"
			_no_button.visible = false
			_tutorial_texture_rect.visible = true
			_load_tutorial_picture()
		"tutorial_action":
			_load_tutorial_picture()
		"tutorial_time":
			_load_tutorial_picture()
		"tutorial_bars":
			_load_tutorial_picture()
		"tutorial_smartphone":
			_load_tutorial_picture()
		"tutorial_banking_app":
			_load_tutorial_picture()
		"tutorial_messenger_app":
			_load_tutorial_picture()
		"tutorial_citzen_app":
			_load_tutorial_picture()
		"tutorial_news_app":
			_load_tutorial_picture()
		"start_game":
			_yes_button.text = "Start Game"
			_tutorial_texture_rect.visible = false
			_no_button.visible = false
		"finished":
			_start_game()


func _load_tutorial_picture():
	# TODO: add tutorial pictures:
	pass
	var texture = ImageTexture.new()
	var image = Image.new()
	image.load("res://assets/tutorial/" + _states[_state] + ".png")
	texture.create_from_image(image)
	_tutorial_texture_rect.texture = texture
	
func _start_game():
	TrafficController.start_cars()
#	NewsController._DEBUG_add_news()
#	CitizenRecord._DEBUG_add_records()
	StoryController.day01_start()
	ViewportManager.change_to_transparent()

func _on_YesButton_pressed():
	_next_state()

func _on_NoButton_pressed():
	_state = _states.find('start_game')
