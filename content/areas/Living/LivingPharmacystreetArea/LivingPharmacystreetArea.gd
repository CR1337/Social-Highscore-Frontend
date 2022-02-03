extends "res://content/areas/Street.gd"

export (NodePath) var leave_pharmacy_area_path
export (Vector2) var leave_pharmacy_player_position

func _ready():

	$LeavePharmacyTriggerArea/LeavePharmacyTrigger.target_area = get_node(leave_pharmacy_area_path)
	$LeavePharmacyTriggerArea/LeavePharmacyTrigger.new_player_position = leave_pharmacy_player_position
