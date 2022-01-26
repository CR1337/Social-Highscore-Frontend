extends Node

var analyze_job_ids: Array
var records: Array


func _ready():
	ImageProcessor.connect("image_processing_done", self, "_on_image_processing_done")

func await_analyze_response(job_id):
	analyze_job_ids.append(job_id)
	print("CitizenRecord added job id: ", job_id)

func _on_image_processing_done(parsed_response, job_id, image):
	if not analyze_job_ids.has(job_id):
		return
	analyze_job_ids.erase(job_id)
	print("CitizenRecord removed job id: ", job_id)
	# TODO

func _add_record(params):
	print("Added record")
	params['time'] = TimeController.get_gametime()
	records.append(params)

func add_emotional_reaction_on_news(score, news, emotion, preferred_emotion):
	var params = {
		'type': 'emotional_reaction_on_news',
		'score': score,
		'news': news,
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
