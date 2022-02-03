extends Node

export var id: String

func _ready():
	EventBus.connect("sig_trigger", self, "_on_trigger")

func _on_trigger(trigger_id):
	if trigger_id == id:
		trigger()

func trigger():
	pass
