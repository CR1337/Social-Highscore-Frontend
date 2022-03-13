tool
extends Node2D

export var is_green: bool setget _set_is_green, _get_is_green
export var has_crosswalk: bool
export (NodePath) var crosswalk
func _set_is_green(value):
	is_green = value
	if value:
		if has_crosswalk:
			get_node(crosswalk).release(self)
		$Sprite.frame = 1
	else:
		if has_crosswalk:
			get_node(crosswalk).occupy(self)
		$Sprite.frame = 0
func _get_is_green():
	return is_green


# Called when the node enters the scene tree for the first time.
func _ready():
	TrafficController.connect("sig_change_traffic_lights", self, "_toggle_trafic_light")

func _toggle_trafic_light():
	_set_is_green(not is_green)

func persistent_state():
	return {
		'is_green': is_green
	}

func restore_state(state):
	_set_is_green(state['is_green'])
