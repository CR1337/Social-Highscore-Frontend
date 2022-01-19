extends "res://content/trigger/Trigger.gd"


func trigger():
	.trigger()
	GameStateController.contact_state['friend'] = 'idle'
