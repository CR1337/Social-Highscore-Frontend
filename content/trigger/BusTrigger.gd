extends "res://content/trigger/Trigger.gd"

var target_overlay: Node2D

func trigger(kwargs):
	.trigger(kwargs)
	if StoryController.day01_bus_enabled:
		# TODO Payment Overlay
		ViewportManager.change_overlay(target_overlay)
	else:
		ViewportManager.change_to_dialog(
			"res://dialogs/other/bus_self_talk.json",
			StoryController.day01_states[StoryController.day01_progress]
		)
