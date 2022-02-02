extends "res://content/areas/Street.gd"

export (NodePath) var leave_pharmacy_area_path
export (Vector2) var leave_pharmacy_player_position

func _ready():

	$LeavePharmacyTriggerArea/LeavePharmacyTrigger.targetArea = get_node(leave_pharmacy_area_path)
	$LeavePharmacyTriggerArea/LeavePharmacyTrigger.newPlayerPosition = leave_pharmacy_player_position
