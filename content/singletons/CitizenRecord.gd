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