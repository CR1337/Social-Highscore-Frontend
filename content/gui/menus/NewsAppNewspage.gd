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
	
	
func _handle_reaction(b64_image, emotion):
	var delta_score;
	if emotion != _news()['preferred_emotion']:
		delta_score = -30
	else:
		delta_score = 20
	CitizenRecord.add_emotional_reaction_on_news(delta_score, _news()['title'], emotion, _news()['preferred_emotion'])
	ViewportManager.change_to_news_app_mainpage()
	_react_button.disabled = false
	_dont_react_button.disabled = false

func _on_DontReactButton_pressed():
	CitizenRecord.add_refused_reaction_on_news(-40, _news()['title'], _news()['preferred_emotion'])
	ViewportManager.change_to_news_app_mainpage()

func _on_ReactButton_pressed():
	_react_button.disabled = true
	_dont_react_button.disabled = true
	_image_processor_job_id = ImageProcessor.analyze()
	
func _on_image_processing_done(parsed_response, job_id, image, raw_image, b64_image):
	if job_id == _image_processor_job_id:
		_image_processor_job_id = -1
		_handle_reaction(b64_image, parsed_response['dominant_emotion'])
