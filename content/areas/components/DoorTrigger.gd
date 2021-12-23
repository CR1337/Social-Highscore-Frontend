extends Node

func _ready():
	InputBus.connect("action_pressed", self, "_on_action_pressed")

func _on_action_pressed():
	get_parent().trigger()
