extends Node2D

export (NodePath) var leaveBottomAreaPath
export (Vector2) var leaveBottomPlayerPosition

export (NodePath) var BusOverlayPath

var active = false

func _ready():
	$LeaveBottomTrigger.targetArea = get_node(leaveBottomAreaPath)
	$LeaveBottomTrigger.newPlayerPosition = leaveBottomPlayerPosition
	
	$BusTrigger.targetOverlay = get_node(BusOverlayPath)
	
