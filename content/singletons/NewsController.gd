extends Node


signal sig_publish_news(title, text, preferred_emotion, lifetime)

var news = []
var _ongoing_reactions = {}

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
	_DEBUG_add_news()


func clear_news():
	# Called when the node enters the scene tree for the first time.
	news = {}
	
func publish_news(title, text, preferred_emotion, lifetime):
	emit_signal("sig_publish_news", title, text, preferred_emotion, lifetime)
	EventBus.emit_signal("sig_notification", 'news', title)
	
func _on_publish_news(title, text, preferred_emotion, lifetime):
	news.append({
		'title': title,
		'text': text,
		'preferred_emotion': preferred_emotion,
		'lifetime': lifetime,
		'age': 0,
		'reacted_on': false,
		'expired': false
	})
	
func react_on(news_index, want_to_react):
	if want_to_react:
		var job_id = ImageProcessor.analyze()
		_ongoing_reactions[job_id] = news_index
	else:
		var news_reacting_on = news[news_index]
		news_reacting_on['reacted_on'] = true
		CitizenRecord.add_refused_reaction_on_news(
			-40, news_reacting_on['title'], news_reacting_on['preferred_emotion']
		)

func _on_image_processing_done(parsed_response, job_id, image, raw_image, b64_image):
	if _ongoing_reactions.has(job_id):
		_handle_reaction(b64_image, parsed_response['dominant_emotion'], _ongoing_reactions[job_id])
		_ongoing_reactions.erase(job_id)
		
func _handle_reaction(b64_image, emotion, news_id_reacting_on):
	var delta_score
	var news_reacting_on = news[news_id_reacting_on]
	news_reacting_on['reacted_on'] = true
	if emotion != news_reacting_on['preferred_emotion']:
		delta_score = -30
	else:
		delta_score = 20
	CitizenRecord.add_emotional_reaction_on_news(
		delta_score, news_reacting_on['title'], b64_image,
		emotion, news_reacting_on['preferred_emotion']
	)
	
#func _oldest_news(skip_running_reactions):
#	var n = news[0]
#	for i in len(news) - 1:
#		if news[i + 1]['age'] > n['age']:
#			if skip_running_reactions and (i + 1) in _ongoing_reactions.values():
#				continue
#			n = news[i + 1]
#	return n
	
#func _erase_news(news_to_erase):

#	news.erase(news_to_erase)



func _on_new_day():
#	var to_erase = []
	for n in news:
		n['age'] += 1
		if n['lifetime'] >= n['age']:
			n['expired'] = true
			if not n['reacted_on']:
				CitizenRecord.add_refused_reaction_on_news(
					-40, n['title'], n['preferred_emotion']
				)
#		to_erase.append(n)
#	for n in to_erase:
#		_erase_news(n)

func _DEBUG_add_news():
	NewsController.publish_news(
		"BREAKING NEWS: We are happy", 
		"The people are happy", 
		'happy',
		1
	);
	NewsController.publish_news(
		"BREAKING NEWS: We are angry", 
		"The people are angry", 
		'angry',
		2
	);
	NewsController.publish_news(
		"BREAKING NEWS: Some other news", 
		"The people are", 
		'happy',
		3
	);
