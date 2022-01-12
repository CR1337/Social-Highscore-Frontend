tool
extends Control

onready var label = $Label
onready var button = $TouchScreenButton

export var transform: Transform2D setget _set_transform, _get_transform
func _set_transform(value):
	label.transform = value
	button.transform = value
func _get_transform():
	return label.transform
	



# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
