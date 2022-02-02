extends Node

var analyze_job_ids: Array
var records: Array


func _ready():
	ImageProcessor.connect("image_processing_done", self, "_on_image_processing_done")

func await_analyze_response(job_id):
	analyze_job_ids.append(job_id)

func _on_image_processing_done(parsed_response, job_id, image):
	if not analyze_job_ids.has(job_id):
		return
	analyze_job_ids.erase(job_id)
	# TODO

func _add_record(params):
	params['time'] = TimeController.get_daytime()
	records.append(params)
	GameStateController.change_score(params['score'])

func add_emotional_reaction_on_news(score, news, face, emotion, preferred_emotion):
	var params = {
		'type': 'emotional_reaction_on_news',
		'score': score,
		'news': news,
		'face': face,
		'emotion': emotion,
		'preferred_emotion': preferred_emotion
	}
	_add_record(params)

func add_refused_reaction_on_news(score, news, preferred_emotion):
	var params = {
		'type': 'refused_reaction_on_news',
		'score': score,
		'news': news,
		'preferred_emotion': preferred_emotion
	}
	_add_record(params)

func add_emotional_reaction_at_authentication(score, place, face, emotion, reason, preferred_emotion):
	var params = {
		'type': 'emotional_reaction_at_authentication',
		'score': score,
		'place': place,
		'face': face,
		'emotion': emotion,
		'reason': reason,
		'preferred_emotion': preferred_emotion
	}
	_add_record(params)

func add_traffic_violation(score, violation_type, place, screenshot):
	var params = {
		'type': 'traffic_violation',
		'score': score,
		'violation_type': violation_type,
		'place': place,
		'screenshot': screenshot
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

func add_critical_speech_in_reallife(score, addressee, text, place, screenshot):
	var params = {
		'type': 'critical_speech_in_reallife',
		'score': score,
		'addressee': addressee,
		'text': text,
		'place': place,
		'screenshot': screenshot
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

func add_contact_to_dissident(score, person, place, screenshot):
	var params = {
		'type': 'contact_to_dissident',
		'score': score,
		'person': person,
		'place': place,
		'screenshot': screenshot
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

func add_lied_to_boss(score, screenshot):
	var params = {
		'type': 'lied_to_boss',
		'score': score,
		'screenshot': screenshot
	}
	_add_record(params)

func add_rescued_friend(score, screenshot):
	var params = {
		'type': 'rescued_friend',
		'score': score,
		'screenshot': screenshot
	}
	_add_record(params)
	
func record_display_string_for_app(record):
	# returns a string describing the record that will be shown to the user in the citizen app
	# maybe put this into file?
	var result = ""
	match record['type']:
		'emotional_reaction_on_news':
			result += "The news was:\n"
			result += record['news'] + "\n"
			result += "Our people were {pref_emo} but you were {emo}.".format({
				'pref_emo': record['preferred_emotion'],
				'emo': record['emotion']
			})
			
		'refused_reaction_on_news':
			result += "The news was:\n"
			result += record['news'] + "\n"
			result += "You refused to share your emotion while our people were {pref_emo}.".format({
				'pref_emo': record['preferred_emotion']
			})
			
		'emotional_reaction_at_authentication':
			result += "You were authenticated at {place} and were {emo} while our people were {pref_emo}\n".format({
				'place': record['place'],
				'pref_emo': record['preferred_emotion'],
				'emo': record['emotion']
			})
			result += "Reason: {reason}".format({
				'reason': record['reason']
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
			
	return result

func persistent_state():
	return {
		'records': records
	}
	
func restore_state(state):
	records = state['records']
	
func _DEBUG_add_records():
	CitizenRecord.add_blood_donation(50)
	CitizenRecord.add_refused_reaction_on_news(-40, 'The economy is good', 'happy')
	CitizenRecord.add_emotional_reaction_on_news(10, 'This is good', Debug.b64_debug_image, 'happy', 'happy')
	CitizenRecord.add_traffic_violation(-10, 'Disregarded traffic light', 'Living Homestreet', Debug.b64_debug_image)
	CitizenRecord.add_organ_donation(100)
	CitizenRecord.add_critical_speech_in_reallife(-10, 'Partner', 'I hate this', 'Home', Debug.b64_debug_image)
	CitizenRecord.add_critical_speech_in_messenger(-10, 'Friend', 'I want to leave')
	CitizenRecord.add_fitness_studio_visit(5)
	CitizenRecord.add_fitness_studio_not_visited(-10)
	CitizenRecord.add_healthy_food_in_restaurant(5, 'Vegetable Soup')
	CitizenRecord.add_unhealthy_food_in_restaurant(-10, 'Burger')
	CitizenRecord.add_healthy_food_at_home(5, 'Fresh Salad')
	CitizenRecord.add_unhealthy_food_at_home(-15, 'ice cream')
	CitizenRecord.add_dept(-100, 500)
	CitizenRecord.add_skipped_work(-50)
	CitizenRecord.add_too_late_to_work(-50, 30)
	CitizenRecord.add_left_work_too_early(-50, 30)
	CitizenRecord.add_didnt_visit_mom(-10, 3)
	CitizenRecord.add_contact_to_dissident(-40, 'Friend', 'Shady Street', Debug.b64_debug_image)
	CitizenRecord.add_reported_dissident(50, 'Friend', 'Critical Speach')
	CitizenRecord.add_lied_to_boss(-20, Debug.b64_debug_image)
	CitizenRecord.add_rescued_friend(-50, Debug.b64_debug_image)
