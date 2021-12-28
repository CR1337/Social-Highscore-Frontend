extends Node

var targetOverlay: Node2D


func trigger():
	ViewportManager.change_overlay(targetOverlay)
