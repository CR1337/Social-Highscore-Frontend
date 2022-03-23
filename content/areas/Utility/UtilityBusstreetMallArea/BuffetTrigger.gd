extends "res://content/trigger/Trigger.gd"


func trigger(kwargs):
	var dialog_filename = "res://dialogs/utility/busstreet/mall/" + get_parent().name.left(7).to_lower() + ".json"
	ViewportManager.change_to_dialog(dialog_filename, "buy")
