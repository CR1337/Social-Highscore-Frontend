extends Node2D

export (NodePath) var leaveRightAreaPath
export (Vector2) var leaveRightPlayerPosition
var active = false

func _ready():
	$LeaveRightTrigger.targetArea = get_node(leaveRightAreaPath)
	$LeaveRightTrigger.newPlayerPosition = leaveRightPlayerPosition
