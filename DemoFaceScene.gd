extends Node2D

func _ready():
	ImageProcessor.connect("image_processing_done", self, "_image_processing_done")
	EventBus.connect("take_face_and_analyze", self, "trigger")

func trigger():
	ImageProcessor.analyze()
	position = Vector2(0, 0)
	
func _image_processing_done(response, handle, image):
	$AgeLabel.text = "Age: " + str(response['age'])
	$EmotionLabel.text = "Emotion: " + response['dominant_emotion']
	$RaceLabel.text = "Race: " + response['dominant_race']
	$GenderLabel.text = "Gender: " + response['gender']
	
	
	
	
