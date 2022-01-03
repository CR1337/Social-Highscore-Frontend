extends Area2D

export var slow_down: bool
export var walkable: bool

func _on_CrosswalkArea_body_entered(body):
	walkable = false


func _on_CrosswalkArea_body_exited(body):
	walkable = true
