extends Area2D

export var slow_down: bool
export var driveThroughable: bool

func _on_CrosswalkArea_body_entered(body):
	driveThroughable = false


func _on_CrosswalkArea_body_exited(body):
	driveThroughable = true
