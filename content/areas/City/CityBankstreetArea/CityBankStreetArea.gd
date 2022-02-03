extends "res://content/areas/Street.gd"

export (NodePath) var leave_office_area_path
export (Vector2) var leave_office_player_position

export (NodePath) var leave_bank_area_path
export (Vector2) var leave_bank_player_position

func _ready():

	$LeaveOfficeTriggerArea/LeaveOfficeTrigger.target_area = get_node(leave_office_area_path)
	$LeaveOfficeTriggerArea/LeaveOfficeTrigger.new_player_position = leave_office_player_position

	$LeaveBankTriggerArea/LeaveBankTrigger.target_area = get_node(leave_bank_area_path)
	$LeaveBankTriggerArea/LeaveBankTrigger.new_player_position = leave_bank_player_position
