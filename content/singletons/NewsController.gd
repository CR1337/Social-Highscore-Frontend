extends Node


signal sig_publish_news()

var news = []
var _ongoing_reactions = {}

func persistent_state():
	return {
		'news': news,
		'image_counter': _image_counter
	}

func restore_state(state):
	news = state['news']
	_image_counter = state['image_counter']

func _ready():
	GameStateController.connect("sig_new_day", self, "_on_new_day")
	ImageProcessor.connect("sig_image_processing_done", self, "_on_image_processing_done")

func clear_news():
	# Called when the node enters the scene tree for the first time.
	news = []

func publish_news(title, text, preferred_emotions, forbidden_emotions, lifetime):
	emit_signal("sig_publish_news")
	EventBus.emit_signal("sig_notification", 'news', title)
	GameStateController.current_preferred_emotions = preferred_emotions
	GameStateController.current_forbidden_emotions = forbidden_emotions
	news.insert(0, {
		'title': title,
		'text': text,
		'preferred_emotions': preferred_emotions,
		'forbidden_emotions': forbidden_emotions,
		'lifetime': lifetime,
		'age': 0,
		'reacted_on': false,
		'expired': false
	})


func react_on(news_index, want_to_react):
	if want_to_react:
		var job_id = ImageProcessor.analyze()
		_ongoing_reactions[int(job_id)] = news_index
	else:
		var news_reacting_on = news[news_index]
		news_reacting_on['reacted_on'] = true
		CitizenRecord.add_refused_reaction_on_news(
			-40, news_reacting_on['title'], news_reacting_on['preferred_emotions']
		)

func _on_image_processing_done(parsed_response, job_id, image, raw_image, b64_image):
	if _ongoing_reactions.has(int(job_id)):
		_handle_reaction(image, parsed_response['dominant_emotion'], _ongoing_reactions[int(job_id)])
		_ongoing_reactions.erase(int(job_id))

var _image_counter = 0
const _image_path = "user://news_reactions/"

func _handle_reaction(image, emotion, news_id_reacting_on):
	var news_reacting_on = news[news_id_reacting_on]
	news_reacting_on['reacted_on'] = true
	var path = _image_path + str(_image_counter) + ".png"
	image.save_png(path)
	_image_counter += 1
	
	if (emotion in news_reacting_on['preferred_emotions']):
		CitizenRecord.add_good_emotional_reaction_on_news(
			20, news_reacting_on['title'], path,
			emotion
		)
	elif emotion in news_id_reacting_on['forbidden_emotions']:
		CitizenRecord.add_bad_emotional_reaction_on_news(
			-30, news_reacting_on['title'], path,
			emotion, news_reacting_on['preferred_emotions']
		)
	else:
		CitizenRecord.add_neutral_emotional_reaction_on_news(
			0, news_reacting_on['title'], path,
			emotion, news_reacting_on['preferred_emotions']
		)

func _on_new_day():
	for n in news:
		n['age'] += 1
		if n['lifetime'] >= n['age']:
			n['expired'] = true
			if not n['reacted_on']:
				CitizenRecord.add_refused_reaction_on_news(
					-40, n['title'], n['preferred_emotions']
				)
