extends Area2D

export var slow_down: float
export var crosswalk: bool

var player_crossing = false
var current_car: Node
var occupied = false
var occupier: Node2D

var blocked = false

var driveThroughable = true setget set_driveThroughable, get_driveThroughable
func set_driveThroughable(value):
	if value == driveThroughable:
		return
	if value:
		collision_layer -= 8
	else:
		collision_layer += 8
	driveThroughable = value
func get_driveThroughable():
	return driveThroughable

func occupy(node):
	occupied = true
	occupier = node
	set_driveThroughable(false)
	
func release(node):
	if node == occupier:
		occupied = false
		occupier = null
		if not player_crossing: 
			set_driveThroughable(true)

func _on_CrosswalkArea_body_entered(body):
	if crosswalk and body.name == "player":
		player_crossing = true
		set_driveThroughable(false)


func _on_CrosswalkArea_body_exited(body):
	if crosswalk and body.name == "player":
		player_crossing = false
		if not occupied: 
			set_driveThroughable(true)

func _on_CrossingArea_area_exited(area):
	release(area)
		

