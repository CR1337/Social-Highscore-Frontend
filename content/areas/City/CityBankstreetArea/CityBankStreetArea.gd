extends "res://content/areas/Street.gd"

export (NodePath) var leave_office_area_path
export (Vector2) var leave_office_player_position

export (NodePath) var leave_bank_area_path
export (Vector2) var leave_bank_player_position

func _ready():

	$LeaveOfficeTriggerArea/LeaveOfficeTrigger.targetArea = get_node(leave_office_area_path)
	$LeaveOfficeTriggerArea/LeaveOfficeTrigger.newPlayerPosition = leave_office_player_position

	$LeaveBankTriggerArea/LeaveBankTrigger.targetArea = get_node(leave_bank_area_path)
	$LeaveBankTriggerArea/LeaveBankTrigger.newPlayerPosition = leave_bank_player_position
