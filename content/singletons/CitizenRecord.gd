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
		'score': score,
		'news': news,
		'emotion': emotion,
		'preferred_emotion': preferred_emotion
	}
	_add_record(params)

func add_refused_reaction_on_news(score, news, preferred_emotion):
	var params = {
		'score': score,
		'news': news,
		'preferred_emotion': preferred_emotion
	}
	_add_record(params)

func add_emotional_reaction_at_authentication(score, place, face, emotion, reason, preferred_emotion):
	var params = {
		'score': score,
		'place': place, 
		'face': face, 
		'emotion': emotion,
		'reason': reason,
		'preferred_emotion': preferred_emotion
	}
	_add_record(params)

