extends "res://content/trigger/Trigger.gd"


func trigger(kwargs):
	.trigger(kwargs)
	if GameStateController.hunger > 0:
		ViewportManager.change_to_fridge()
	else: 
		ViewportManager.change_to_dialog(
			"res://dialogs/other/fridge_self_talk.json", 
			"not_hungry"
		)
