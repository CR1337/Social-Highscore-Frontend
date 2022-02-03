extends "res://content/areas/Street.gd"

export (NodePath) var leave_hospital_area_path
export (Vector2) var leave_hospital_player_position

export (NodePath) var leave_mall_area_path
export (Vector2) var leave_mall_player_position

export (NodePath) var bus_overlay_path

func _ready():

	$LeaveHospitalTriggerArea/LeaveHospitalTrigger.target_area = get_node(leave_hospital_area_path)
	$LeaveHospitalTriggerArea/LeaveHospitalTrigger.new_player_position = leave_hospital_player_position

	$LeaveMallTriggerArea/LeaveMallTrigger.target_area = get_node(leave_mall_area_path)
	$LeaveMallTriggerArea/LeaveMallTrigger.new_player_position = leave_mall_player_position

	$BusTriggerArea/BusTrigger.target_overlay = get_node(bus_overlay_path)
