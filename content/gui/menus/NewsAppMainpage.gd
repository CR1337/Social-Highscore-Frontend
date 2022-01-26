extends Node2D

onready var _news_buttons = [
	$Background/MarginContainer/VBoxContainer/News0Button,
	$Background/MarginContainer/VBoxContainer/News1Button,
	$Background/MarginContainer/VBoxContainer/News2Button
]

func _ready():
	NewsController.connect("sig_publish_news", self, "_on_publish_news")
	call_deferred("update_mainpage")
	
	call_deferred("_DEBUG_add_news")

func update_mainpage():
	for i in len(_news_buttons):
		if (len(NewsController.news) - 1) < i:
			_news_buttons[i].disabled = true
			_news_buttons[i].text = ""
		else:
			_news_buttons[i].disabled = false
			_news_buttons[i].text = NewsController.news[i]['title']

func _on_BackButton_pressed():
	ViewportManager.change_to_smartphone()

func _on_News0Button_pressed():
	ViewportManager.change_to_news_app_newspage(0)

func _on_News1Button_pressed():
	ViewportManager.change_to_news_app_newspage(1)

func _on_News2Button_pressed():
	ViewportManager.change_to_news_app_newspage(2)
	
func _on_publish_news(title, text, preferred_emotion):
	call_deferred("update_mainpage")
	
func _DEBUG_add_news():
	NewsController.publish_news(
		"BREAKING NEWS: We are happy", 
		"The people are happy", 
		'happy'
	);
	NewsController.publish_news(
		"BREAKING NEWS: We are angry", 
		"The people are angry", 
		'angry'
	);
