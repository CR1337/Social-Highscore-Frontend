tool
extends Node2D

export var is_on: bool setget _set_is_on, _get_is_on
export var has_crosswalk: bool
export (NodePath) var crosswalk
func _set_is_on(value):
	is_on = value
	if value:
		if has_crosswalk:
			get_node(crosswalk).occupy(self)
		$Sprite.frame = 1
	else:
		if has_crosswalk:
			get_node(crosswalk).release(self)
		$Sprite.frame = 0
func _get_is_on():
	return is_on


# Called when the node enters the scene tree for the first time.
func _ready():
	TrafficController.connect("sig_change_traffic_lights", self, "_toggle_trafic_light")

func _toggle_trafic_light():
	_set_is_on(not is_on)

func persistent_state():
	return {
		'is_on': is_on
	}

func restore_state(state):
	_set_is_on(state['is_on'])
