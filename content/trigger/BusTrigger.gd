extends "res://content/trigger/Trigger.gd"

var target_overlay: Node2D

func trigger():
	.trigger()
	ViewportManager.change_overlay(target_overlay)
