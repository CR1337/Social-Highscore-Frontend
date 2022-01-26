extends Node


signal sig_publish_news(title, text, preferred_emotion)

var news = []

func persistent_state():
	return {
		'news': news
	}
	
func restore_state(state):
	news = state['news']

func _ready():
	connect("sig_publish_news", self, "_on_publish_news")

func clear_news():
	# Called when the node enters the scene tree for the first time.
	news = []
	
func publish_news(title, text, preferred_emotion):
	emit_signal("sig_publish_news", title, text, preferred_emotion)

func _on_publish_news(title, text, preferred_emotion):
	news.append({
		'title': title,
		'text': text,
		'preferred_emotion': preferred_emotion
	})
