extends "res://content/areas/Street.gd"

export (NodePath) var leaveStoreAreaPath
export (Vector2) var leaveStorePlayerPosition

func _ready():

	$LeaveStoreTriggerArea/LeaveStoreTrigger.targetArea = get_node(leaveStoreAreaPath)
	$LeaveStoreTriggerArea/LeaveStoreTrigger.newPlayerPosition = leaveStorePlayerPosition
