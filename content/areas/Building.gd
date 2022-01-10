extends Node2D

export (NodePath) var leaveAreaPath
export (Vector2) var leavePlayerPosition


func _ready():
	if leaveAreaPath != "":
		$LeaveTrigger.targetArea = get_node(leaveAreaPath)
		$LeaveTrigger.newPlayerPosition = leavePlayerPosition

