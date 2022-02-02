extends "res://content/areas/Street.gd"

export (NodePath) var leave_hospital_area_path
export (Vector2) var leave_hospital_player_position

export (NodePath) var leave_mall_area_path
export (Vector2) var leave_mall_player_position

export (NodePath) var bus_overlay_path

func _ready():

	$LeaveHospitalTriggerArea/LeaveHospitalTrigger.targetArea = get_node(leave_hospital_area_path)
	$LeaveHospitalTriggerArea/LeaveHospitalTrigger.newPlayerPosition = leave_hospital_player_position

	$LeaveMallTriggerArea/LeaveMallTrigger.targetArea = get_node(leave_mall_area_path)
	$LeaveMallTriggerArea/LeaveMallTrigger.newPlayerPosition = leave_mall_player_position

	$BusTriggerArea/BusTrigger.targetOverlay = get_node(bus_overlay_path)
