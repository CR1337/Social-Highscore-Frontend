extends Node

var analyze_job_ids: Array

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
