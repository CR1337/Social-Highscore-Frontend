tool
extends Area2D

var _walkable = false
var _traffic_light: Node2D

func occupy(node):
	_walkable = false
	_traffic_light = node

func release(node):
	if _traffic_light == node:
		_walkable = true
		_traffic_light = null

func _on_CrosswalkArea_body_entered(body):
	if body.name == "Player":
		if not _walkable:
			CitizenRecord.add_traffic_violation(-10, "Red traffic light", ViewportManager.current_place_string())
