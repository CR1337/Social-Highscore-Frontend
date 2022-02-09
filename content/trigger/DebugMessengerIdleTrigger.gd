extends "res://content/trigger/DialogTrigger.gd"


func trigger(kwargs):
	.trigger(kwargs)
	GameStateController.contact_state['friend'] = 'idle'
