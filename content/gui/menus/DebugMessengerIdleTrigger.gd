extends "res://content/trigger/DialogTrigger.gd"


func trigger():
	.trigger()
	print("state to idle")
	GameStateController.contact_state['friend'] = 'idle'
