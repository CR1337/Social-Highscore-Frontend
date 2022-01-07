tool
extends Node2D

export var is_on: bool setget _setIsOn, _getIsOn
export var has_crosswalk: bool
export (NodePath) var crosswalk
func _setIsOn(value):
	is_on = value
	if value:
		if has_crosswalk:
			get_node(crosswalk).occupy(self)
		$Sprite.frame = 1
	else:
		if has_crosswalk:
			get_node(crosswalk).release(self)
		$Sprite.frame = 0
func _getIsOn():
	return is_on


# Called when the node enters the scene tree for the first time.
func _ready():
	TimeController.connect("change_traffic_lights", self, "_toggle_trafic_light")

func _toggle_trafic_light():
	_setIsOn(not is_on)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
