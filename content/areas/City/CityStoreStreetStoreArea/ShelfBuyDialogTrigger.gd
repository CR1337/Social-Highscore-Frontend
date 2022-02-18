extends "res://content/trigger/Trigger.gd"


func trigger(kwargs):
	var dialog_filename = "res://dialogs/city/storestreet/store/" + get_parent().name.left(6).to_lower() + ".json"
	if GameStateController.remaining_shopping_capacity() > 0:
		ViewportManager.change_to_dialog(dialog_filename, "buy")
	else:
		ViewportManager.change_to_dialog(dialog_filename, "full")
