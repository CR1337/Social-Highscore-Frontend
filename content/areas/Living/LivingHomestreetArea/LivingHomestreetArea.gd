extends Node2D

export (NodePath) var leaveLeftAreaPath
export (Vector2) var leaveLeftUpperPlayerPosition
export (Vector2) var leaveLeftLowerPlayerPosition


func _ready():
	$LeaveLeftUpperTrigger.targetArea = get_node(leaveLeftAreaPath)
	$LeaveLeftUpperTrigger.newPlayerPosition = leaveLeftUpperPlayerPosition
	
	$LeaveLeftLowerTrigger.targetArea = get_node(leaveLeftAreaPath)
	$LeaveLeftLowerTrigger.newPlayerPosition = leaveLeftLowerPlayerPosition
	
