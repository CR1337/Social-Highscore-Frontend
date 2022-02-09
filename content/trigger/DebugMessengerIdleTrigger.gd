extends "res://content/trigger/DialogTrigger.gd"


func trigger():
	.trigger()
	GameStateController.contact_state['friend'] = 'idle'
