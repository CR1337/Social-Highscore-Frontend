extends Node2D

export (NodePath) var leaveAreaPath
export (Vector2) var leavePlayerPosition

func _ready():
	$LeaveTrigger.targetArea = get_node(leaveAreaPath)
	$LeaveTrigger.newPlayerPosition = leavePlayerPosition
	
