extends Node2D


onready var _title_label = $Background/MarginContainer/VBoxContainer/TitleHBoxContainer/TitleLabel
onready var _text_label = $Background/MarginContainer/VBoxContainer/TextLabel
onready var _react_button = $Background/MarginContainer/VBoxContainer/HBoxContainer/ReactButton
onready var _dont_react_button = $Background/MarginContainer/VBoxContainer/HBoxContainer/DontReactButton

var _image_processor_job_id = -1
var _news_index = -1

func persistent_state():
	return {
		'news_index': _news_index
	}
	
func restore_state(state):
	call_deferred("update_newspage", state['news_index'])

func _ready():
	ImageProcessor.connect("image_processing_done", self, "_on_image_processing_done")

func _news():
	return NewsController.news[_news_index]

func update_newspage(news_index):
	if news_index < 0:
		return
	_news_index = news_index
	_title_label.text = _news()['title']
	_text_label.clear()
	_text_label.append_bbcode(_news()['text'])
	
	if _news()['reacted_on']:
		_react_button.disabled = true
		_react_button.text = ""
		_dont_react_button.text = "Back"
	else:
		_react_button.disabled = false
		_react_button.text = "React"
		_dont_react_button.text = "Don't react"

func _on_DontReactButton_pressed():
	if not _news()['reacted_on']:
		NewsController.react_on(_news_index, false)
	ViewportManager.change_to_news_app_mainpage()

func _on_ReactButton_pressed():
	NewsController.react_on(_news_index, true)
	ViewportManager.change_to_news_app_mainpage()
