extends "res://content/areas/Street.gd"

export (NodePath) var leaveFriendAreaPath
export (Vector2) var leaveFriendPlayerPosition

export (NodePath) var leavePartnerAreaPath
export (Vector2) var leavePartnerPlayerPosition

func _ready():
	
	$LeaveFriendTriggerArea/LeaveFriendTrigger.targetArea = get_node(leaveFriendAreaPath)
	$LeaveFriendTriggerArea/LeaveFriendTrigger.newPlayerPosition = leaveFriendPlayerPosition

	$LeavePartnerTriggerArea/LeavePartnerTrigger.targetArea = get_node(leavePartnerAreaPath)
	$LeavePartnerTriggerArea/LeavePartnerTrigger.newPlayerPosition = leavePartnerPlayerPosition
	
	cars = {
		2: $car_2
	}
