extends "res://content/areas/Street.gd"


export (NodePath) var leavePoliceAreaPath
export (Vector2) var leavePolicePlayerPosition

func _ready():

	$LeavePoliceTriggerArea/LeavePoliceTrigger.targetArea = get_node(leavePoliceAreaPath)
	$LeavePoliceTriggerArea/LeavePoliceTrigger.newPlayerPosition = leavePolicePlayerPosition
