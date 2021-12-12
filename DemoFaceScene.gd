extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	ImageProcessor.connect("image_processing_done", self, "_image_processing_done")
	EventBus.connect("take_face_and_analyze", self, "trigger")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func trigger():
	ImageProcessor.analyze()
	position = Vector2(0, 0)
	
func _image_processing_done(response, handle, image):
	$AgeLabel.text = "Age: " + str(response.result['age'])
	$EmotionLabel.text = "Emotion: " + response.result['dominant_emotion']
	$RaceLabel.text = "Race: " + response.result['dominant_race']
	$GenderLabel.text = "Gender: " + response.result['gender']
	
	
	
	
