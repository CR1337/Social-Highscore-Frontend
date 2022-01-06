extends Area2D

export var slow_down: float

export var crosswalk: bool

var player_crossing = false
var current_car: Node
var occupied = false
var occupier: Area2D
var driveThroughable: bool
var blocked = false

func occupy(node):
	occupied = true
	occupier = node

func _on_CrosswalkArea_body_entered(body):
	if crosswalk and body.name == "player":
		player_crossing = true
		driveThroughable = false


func _on_CrosswalkArea_body_exited(body):
	if crosswalk and body.name == "player":
		player_crossing = false
		if not blocked: 
			driveThroughable = true

func _on_CrossingArea_area_exited(area):
	if area == occupier:
		occupied = false
		occupier = null
		
func block():
	blocked = true
	driveThroughable = false
func release():
	blocked = false
	if not player_crossing:
		driveThroughable = true
