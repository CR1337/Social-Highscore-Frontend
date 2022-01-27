extends Node


signal sig_publish_news(title, text, preferred_emotion, lifetime)

var news = []
var _image_processor_job_id = -1
var _news_index_reacting_on = -1
const _max_n_news = 3

func persistent_state():
	return {
		'news': news
	}
	
func restore_state(state):
	news = state['news']

func _ready():
	connect("sig_publish_news", self, "_on_publish_news")
	TimeController.connect("sig_new_day", self, "_on_new_day")
	ImageProcessor.connect("image_processing_done", self, "_on_image_processing_done")

func clear_news():
	# Called when the node enters the scene tree for the first time.
	news = []
	
func publish_news(title, text, preferred_emotion, lifetime):
	emit_signal("sig_publish_news", title, text, preferred_emotion, lifetime)
	EventBus.emit_signal("sig_notification", 'news', title)
	
func react_on(news_index, want_to_react):
	if want_to_react:
		_image_processor_job_id = ImageProcessor.analyze()
		_news_index_reacting_on = news_index
	else:
		var news_reacting_on = news[news_index]
		news_reacting_on['reacted_on'] = true
		CitizenRecord.add_refused_reaction_on_news(
			-40, news_reacting_on['title'], news_reacting_on['preferred_emotion']
		)

func _on_image_processing_done(parsed_response, job_id, image, raw_image, b64_image):
	if job_id == _image_processor_job_id:
		_image_processor_job_id = -1
		_handle_reaction(b64_image, parsed_response['dominant_emotion'])
		
func _handle_reaction(b64_image, emotion):
	var delta_score;
	var news_reacting_on = news[_news_index_reacting_on]
	news_reacting_on['reacted_on'] = true
	if emotion != news_reacting_on['preferred_emotion']:
		delta_score = -30
	else:
		delta_score = 20
	CitizenRecord.add_emotional_reaction_on_news(
		delta_score, news_reacting_on['title'], b64_image,
		emotion, news_reacting_on['preferred_emotion']
	)
	_news_index_reacting_on = -1;
	
func _oldest_news():
	var n = news[0]
	for i in len(news) - 1:
		if news[i + 1]['age'] > n['age']:
			n = news[i + 1]
	return n
	
func _erase_news(news_to_erase):
	if not news_to_erase['reacted_on']:
		CitizenRecord.add_refused_reaction_on_news(
			-40, news_to_erase['title'], news_to_erase['preferred_emotion']
		)
	news.erase(news_to_erase)

func _on_publish_news(title, text, preferred_emotion, lifetime):
	while len(news) >= _max_n_news:
		_erase_news(_oldest_news())
	news.append({
		'title': title,
		'text': text,
		'preferred_emotion': preferred_emotion,
		'lifetime': lifetime,
		'age': 0,
		'reacted_on': false
	})

func _on_new_day():
	var to_erase = []
	for n in news:
		n['age'] += 1
		if n['lifetime'] >= n['age']:
			to_erase.append(n)
	for n in to_erase:
		_erase_news(n)
