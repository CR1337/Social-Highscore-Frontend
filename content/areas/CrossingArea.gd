extends Area2D

export var slow_down: float
export var driveThroughable: bool
export var crosswalk: bool

var current_car: Node
var occupied = false
var occupier: Area2D

func occupy(node):
	occupied = true
	occupier = node

func _on_CrosswalkArea_body_entered(body):
	if crosswalk and body.name == "player":
		driveThroughable = false


func _on_CrosswalkArea_body_exited(body):
	if crosswalk and body.name == "player":
		driveThroughable = true
		
func setDriveThrougable(value):
	driveThroughable = value


func _on_CrossingArea_area_exited(area):
	if area == occupier:
		occupied = false
		occupier = null
		
		
