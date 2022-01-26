extends "res://content/areas/Street.gd"

export (NodePath) var leaveOfficeAreaPath
export (Vector2) var leaveOfficePlayerPosition

export (NodePath) var leaveBankAreaPath
export (Vector2) var leaveBankPlayerPosition

func _ready():

	$LeaveOfficeTriggerArea/LeaveOfficeTrigger.targetArea = get_node(leaveOfficeAreaPath)
	$LeaveOfficeTriggerArea/LeaveOfficeTrigger.newPlayerPosition = leaveOfficePlayerPosition
	
	$LeaveBankTriggerArea/LeaveBankTrigger.targetArea = get_node(leaveBankAreaPath)
	$LeaveBankTriggerArea/LeaveBankTrigger.newPlayerPosition = leaveBankPlayerPosition
