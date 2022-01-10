extends "res://content/areas/Street.gd"

export (NodePath) var leaveFriendAreaPath
export (Vector2) var leaveFriendPlayerPosition

export (NodePath) var leavePartnerAreaPath
export (Vector2) var leavePartnerPlayerPosition

func _ready():
	
	$LeaveFriendTrigger.targetArea = get_node(leaveFriendAreaPath)
	$LeaveFriendTrigger.newPlayerPosition = leaveFriendPlayerPosition

	$LeavePartnerTrigger.targetArea = get_node(leavePartnerAreaPath)
	$LeavePartnerTrigger.newPlayerPosition = leavePartnerPlayerPosition
	
	cars = {
		2: $car_2
	}
