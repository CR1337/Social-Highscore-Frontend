extends Node

var _analyze_job_ids: Array
var records: Array

var _image_counter = 0
const _image_path = "user://authentication_emotions/"
func _ready():
	ImageProcessor.connect("sig_image_processing_done", self, "_on_image_processing_done")

func await_analyze_response(job_id):
	_analyze_job_ids.append(int(job_id))

func _on_image_processing_done(parsed_response, job_id, image, raw_image, b64_image):
	if not _analyze_job_ids.has(int(job_id)):
		return
	_analyze_job_ids.erase(int(job_id))
	var emotion = parsed_response['dominant_emotion']
	var path = _image_path + str(_image_counter) + ".png"
	var place = ViewportManager.current_place_string()
	image.save_png(path)
	_image_counter += 1
	if emotion in GameStateController.current_preferred_emotions:
		CitizenRecord.add_good_emotional_reaction_at_authentication(
			20, place, path,
			emotion
		)
	elif emotion in GameStateController.current_forbidden_emotions:
		CitizenRecord.add_bad_emotional_reaction_at_authentication(
			-30, place, path,
			emotion, GameStateController.current_preferred_emotions
		)

func _add_record(params):
	records.append(params)
	GameStateController.change_score(params['score'])

func add_debug(score):
	var params = {
		'type': 'debug',
		'score': score
	}
	_add_record(params)

func add_score_class_changed(new_class):
	var params = {
		'type': 'score_class_changed',
		'score': 0,
		'new_class': new_class
	}
	_add_record(params)

func add_good_emotional_reaction_on_news(score, news, face, emotion):
	var params = {
		'type': 'good_emotional_reaction_on_news',
		'score': score,
		'news': news,
		'face': face,
		'emotion': emotion
	}
	_add_record(params)

func add_bad_emotional_reaction_on_news(score, news, face, emotion, preferred_emotions):
	var params = {
		'type': 'bad_emotional_reaction_on_news',
		'score': score,
		'news': news,
		'face': face,
		'emotion': emotion,
		'preferred_emotions': preferred_emotions
	}
	_add_record(params)

func add_neutral_emotional_reaction_on_news(score, news, face, emotion, preferred_emotions):
	var params = {
		'type': 'neutral_emotional_reaction_on_news',
		'score': score,
		'news': news,
		'face': face,
		'emotion': emotion,
		'preferred_emotions': preferred_emotions
	}
	_add_record(params)

func add_refused_reaction_on_news(score, news, preferred_emotions):
	var params = {
		'type': 'refused_reaction_on_news',
		'score': score,
		'news': news,
		'preferred_emotions': preferred_emotions
	}
	_add_record(params)

func add_good_emotional_reaction_at_authentication(score, place, face, emotion):
	var params = {
		'type': 'good_emotional_reaction_at_authentication',
		'score': score,
		'place': place,
		'face': face,
		'emotion': emotion
	}
	_add_record(params)
	
func add_bad_emotional_reaction_at_authentication(score, place, face, emotion, preferred_emotions):
	var params = {
		'type': 'bad_emotional_reaction_at_authentication',
		'score': score,
		'place': place,
		'face': face,
		'emotion': emotion,
		'preferred_emotions': preferred_emotions
	}
	_add_record(params)
	
func add_neutral_emotional_reaction_at_authentication(score, place, face, emotion, preferred_emotions):
	var params = {
		'type': 'neutral_emotional_reaction_at_authentication',
		'score': score,
		'place': place,
		'face': face,
		'emotion': emotion,
		'preferred_emotions': preferred_emotions
	}
	_add_record(params)

func add_traffic_violation(score, violation_type, place):
	var params = {
		'type': 'traffic_violation',
		'score': score,
		'violation_type': violation_type,
		'place': place,
		'screenshot': _take_screenshot()
	}
	_add_record(params)

func add_blood_donation(score):
	var params = {
		'type': 'blood_donation',
		'score': score,

	}
	_add_record(params)

func add_organ_donation(score):
	var params = {
		'type': 'organ_donation',
		'score': score,

	}
	_add_record(params)

func add_critical_speech_in_messenger(score, addressee, text):
	var params = {
		'type': 'critical_speech_in_messenger',
		'score': score,
		'addressee': addressee,
		'text': text
	}
	_add_record(params)

func add_critical_speech_in_reallife(score, addressee, text, place):
	var params = {
		'type': 'critical_speech_in_reallife',
		'score': score,
		'addressee': addressee,
		'text': text,
		'place': place,
		'screenshot': _take_screenshot()
	}
	_add_record(params)

func add_fitness_studio_visit(score):
	var params = {
		'type': 'fitness_studio_visit',
		'score': score,

	}
	_add_record(params)

func add_fitness_studio_not_visited(score):
	var params = {
		'type': 'fitness_studio_not_visited',
		'score': score,

	}
	_add_record(params)

func add_healthy_food_in_restaurant(score, food):
	var params = {
		'type': 'healthy_food_in_restaurant',
		'score': score,
		'food': food
	}
	_add_record(params)

func add_unhealthy_food_in_restaurant(score, food):
	var params = {
		'type': 'unhealthy_food_in_restaurant',
		'score': score,
		'food': food
	}
	_add_record(params)

func add_healthy_food_at_home(score, food):
	var params = {
		'type': 'healthy_food_at_home',
		'score': score,
		'food': food
	}
	_add_record(params)

func add_unhealthy_food_at_home(score, food):
	var params = {
		'type': 'unhealthy_food_at_home',
		'score': score,
		'food': food
	}
	_add_record(params)

func add_dept(score, amount):
	var params = {
		'type': 'dept',
		'score': score,
		'amount': amount
	}
	_add_record(params)

func add_skipped_work(score):
	var params = {
		'type': 'skipped_work',
		'score': score,

	}
	_add_record(params)

func add_too_late_to_work(score, amount_of_time):
	var params = {
		'type': 'too_late_to_work',
		'score': score,
		'amount_of_time': amount_of_time
	}
	_add_record(params)

func add_left_work_too_early(score, amount_of_time):
	var params = {
		'type': 'left_work_too_early',
		'score': score,
		'amount_of_time': amount_of_time
	}
	_add_record(params)

func add_didnt_visit_mom(score, amount_of_time):
	var params = {
		'type': 'didnt_visit_mom',
		'score': score,
		'amount_of_time': amount_of_time
	}
	_add_record(params)

func add_contact_to_dissident(score, person, place):
	var params = {
		'type': 'contact_to_dissident',
		'score': score,
		'person': person,
		'place': place,
		'screenshot': _take_screenshot()
	}
	_add_record(params)

func add_reported_dissident(score, person, reason):
	var params = {
		'type': 'reported_dissident',
		'score': score,
		'person': person,
		'reason': reason
	}
	_add_record(params)

func add_lied_to_boss(score):
	var params = {
		'type': 'lied_to_boss',
		'score': score,
		'screenshot': _take_screenshot()
	}
	_add_record(params)

func add_rescued_friend(score):
	var params = {
		'type': 'rescued_friend',
		'score': score,
		'screenshot': _take_screenshot()
	}
	_add_record(params)

func add_no_job(score):
	var params = {
		'type': 'no_job',
		'score': score
	}
	_add_record(params)

var _screenshot_counter = 0
const _screenshot_path = "user://screenshots/screenshot"

func _take_screenshot():
	var image = get_viewport().get_texture().get_data()
	var path = _screenshot_path + str(_screenshot_counter) + ".png"
	image.flip_y()
	image.crop(768, 1024)
	image.save_png(path)
	_screenshot_counter += 1
	return path

func _emotion_string(preferred_emotions):
	if len(preferred_emotions) == 1:
		return preferred_emotions[0]
	elif len(preferred_emotions) == 2:
		return preferred_emotions[0] + " and " + preferred_emotions[1]
	else:
		return preferred_emotions[0] + ", " + _emotion_string(
			preferred_emotions.slice(1, len(preferred_emotions) - 1)
		)

func record_display_string_for_app(record):
	# returns a string describing the record that will be shown to the user in the citizen app
	# maybe put this into file?
	var result = ""
	match record['type']:
		'debug':
			result += "DEBUG"
		'score_class_changed':
			result += "Your score class changed to class "
			result += str(record['new_class'])


		'good_emotional_reaction_on_news':
			result += "The news was:\n"
			result += record['news'] + "\n"
			result += "You showed solidarity with the community by being {emo} together. ".format({
				'emo': record['emotion']
			})

		'bad_emotional_reaction_on_news':
			result += "The news was:\n"
			result += record['news'] + "\n"
			result += "Society was {pref_emo}, but you were {emo}. Show more solidarity with your fellow citizens in the future.".format({
				'pref_emo': _emotion_string(record['preferred_emotions']),
				'emo': record['emotion']
			})

		'neutral_emotional_reaction_on_news':
			result += "The news was:\n"
			result += record['news'] + "\n"
			result += "The society was {pref_emo}, but you seemed {emo}. In the future, try to show your emotions to your fellow human beings. ".format({
				'pref_emo': _emotion_string(record['preferred_emotions']),
				'emo': record['emotion']
			})

		'refused_reaction_on_news':
			result += "The news was:\n"
			result += record['news'] + "\n"
			result += "You refused to share your emotion while our people were {pref_emo}.".format({
				'pref_emo': _emotion_string(record['preferred_emotions'])
			})

		'good_emotional_reaction_at_authentication':
			result += "You were authenticated at {place} and showed up {emo}. By doing so, you showed solidarity with society.".format({
				'place': record['place'],
				'emo': record['emotion']
			})
			
		'bad_emotional_reaction_at_authentication':
			result += "You were authenticated at {place} and showed up {emo}. However, society was {pref_emo}. Show more solidarity with the mood of your fellow citizens in the future.".format({
				'place': record['place'],
				'pref_emo': _emotion_string(record['preferred_emotions']),
				'emo': record['emotion']
			})
			
		'neutral_emotional_reaction_at_authentication':
			result += "You were authenticated at {place} and showed up {emo}. However, society was {pref_emo}. In the future, try to share your true emotions with society. ".format({
				'place': record['place'],
				'pref_emo': _emotion_string(record['preferred_emotions']),
				'emo': record['emotion']
			})

		'traffic_violation':
			result += "You jaywalked at {place}.".format({
				'place': record['place']
			})

		'blood_donation':
			result += "You donated blood."

		'organ_donation':
			result += "You donated a kidney."

		'critical_speech_in_messenger':
			result += "You texted hate speech to {addressee}:\n".format({
				'addressee': record['addressee']
			})
			result += record['text']

		'critical_speech_in_reallife':
			result += "You talked hate speech to {addressee} at {place}:\n".format({
				'addressee': record['addressee'],
				'place': record['place']
			})
			result += record['text']

		'fitness_studio_visit':
			result += "You visited the fitness studio."

		'fitness_studio_not_visited':
			result += "You did not visit fitness studio frequently."

		'healthy_food_in_restaurant':
			result += "You cosumed {food} at an Restaurant. Good job, that was healthy.".format({
				'food': record['food']
			})

		'unhealthy_food_in_restaurant':
			result += "You consumed {food} at an Restaurant. Thats unhealthy behavior".format({
				'food': record['food']
			})

		'healthy_food_at_home':
			result += "You bought {food}. Good job, that is healthy.".format({
				'food': record['food']
			})

		'unhealthy_food_at_home':
			result += "You bought {food}. Thats unhealthy behavior".format({
				'food': record['food']
			})

		'dept':
			result += "You are {amount} ¥ in dept.".format({
				'amount': record['amount']
			})

		'skipped_work':
			result += "You didn't show up for work."

		'too_late_to_work':
			result += "You were too late to work."

		'left_work_too_early':
			result += "You left work too early."

		'didnt_visit_mom':
			result += "You didn't visit your mom often enough."

		'contact_to_dissident':
			result += "You had contact to an enemy of the people at {place}.".format({
				'place': record['place']
			})

		'reported_dissident':
			result += "You reported an enemy of the people."

		'lied_to_boss':
			result += "You lied to your supervisor."

		'rescued_friend':
			result += "You helped an enemy of the people escape from prison."

		'no_job':
			result += "You don't have a job. That is considered unsocial behavior. Please get in touch with your local jobcenter consultant tomorrow between 9 and 12 am."

	return result

func persistent_state():
	return {
		'records': records,
		'image_counter': _image_counter,
		'screenshot_counter': _screenshot_counter
	}

func restore_state(state):
	records = state['records']
	_image_counter = state['image_counter']
	_screenshot_counter = state['screenshot_counter']

