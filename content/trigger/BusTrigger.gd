extends "res://content/trigger/Trigger.gd"

var targetOverlay: Node2D

func trigger():
	.trigger()
	ViewportManager.change_overlay(targetOverlay)
