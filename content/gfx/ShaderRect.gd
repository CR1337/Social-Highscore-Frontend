extends ColorRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var area_change_duration = 0.2
var _area_change_counter = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func cover():
	material.set_shader_param("opacity", 1)

func area_change():
	_area_change_counter = area_change_duration

func _process(delta):
	process_area_change(delta)

func process_area_change(delta):
	var opacity = 0
	if _area_change_counter > 0:
		_area_change_counter -= delta
		if _area_change_counter <= 0:
			_area_change_counter = 0
		else:
			opacity = sin(
				(2 * area_change_duration - _area_change_counter)
				/ (2 * area_change_duration) * PI
			)
		material.set_shader_param("opacity", opacity)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
