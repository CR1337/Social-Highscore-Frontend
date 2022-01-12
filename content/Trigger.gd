extends Node

export var id: String

func _ready():
	EventBus.connect("trigger", self, "_on_trigger")
	
func _on_trigger(trigger_id):
	if trigger_id == id:
		trigger()
		
func trigger():
	# debugging
	print("TRIGGER: ", id)
