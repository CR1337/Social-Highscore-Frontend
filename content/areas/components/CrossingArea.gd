extends Area2D

export var slow_down: float
export var crosswalk: bool

var _player_crossing = false
var _occupied = false
var _occupier: Node2D

var _drive_throughable = true setget set_driveThroughable, get_driveThroughable
func set_driveThroughable(value):
	if value == _drive_throughable:
		return
	if value:
		collision_layer -= 8
	else:
		collision_layer += 8
		_drive_throughable = value

func get_driveThroughable():
	return _drive_throughable

func occupy(node):
	_occupied = true
	_occupier = node
	set_driveThroughable(false)

func release(node):
	if node == _occupier:
		_occupied = false
		_occupier = null
		if not _player_crossing:
			set_driveThroughable(true)

func _on_CrosswalkArea_body_entered(body):
	if crosswalk and body.name == "player":
		_player_crossing = true
		set_driveThroughable(false)


func _on_CrosswalkArea_body_exited(body):
	if crosswalk and body.name == "player":
		_player_crossing = false
		if not _occupied:
			set_driveThroughable(true)

func _on_CrossingArea_area_exited(area):
	release(area)


