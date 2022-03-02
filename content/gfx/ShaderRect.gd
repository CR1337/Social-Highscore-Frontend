extends ColorRect

export var blend_duration = 0.2
var _blend_counter = 0

func cover():
	material.set_shader_param("opacity", 1)

func _process(delta):
	process_blending(delta)

func blend_with_color(color):
	match color:
		'black': 
			material.set_shader_param("color", Vector3(0.0, 0.0, 0.0))
		'red': 
			material.set_shader_param("color", Vector3(1.0, 0.0, 0.0))
		'green': 
			material.set_shader_param("color", Vector3(0.0, 1.0, 0.0))
	print(material.get_shader_param("color"))
	_blend_counter = blend_duration

func process_blending(delta):
	var opacity = 0
	if _blend_counter > 0:
		_blend_counter -= delta
		if _blend_counter <= 0:
			_blend_counter = 0
		else:
			opacity = sin(
				(2 * blend_duration - _blend_counter)
				/ (2 * blend_duration) * PI
			)
		material.set_shader_param("opacity", opacity)
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
