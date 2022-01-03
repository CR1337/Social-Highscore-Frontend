extends Area2D

export var slow_down: float
export var driveThroughable: bool
export var crosswalk: bool

func _on_CrosswalkArea_body_entered(body):
	if crosswalk:
		driveThroughable = false


func _on_CrosswalkArea_body_exited(body):
	if crosswalk:
		driveThroughable = true
