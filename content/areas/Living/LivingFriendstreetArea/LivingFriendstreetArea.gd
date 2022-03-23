extends "res://content/areas/Street.gd"

export (NodePath) var leave_friend_area_path
export (Vector2) var leave_friend_player_position

export (NodePath) var leave_partner_area_path
export (Vector2) var leave_partner_player_position

func _ready():

	$LeaveFriendTriggerArea/LeaveFriendTrigger.target_area = get_node(leave_friend_area_path)
	$LeaveFriendTriggerArea/LeaveFriendTrigger.new_player_position = leave_friend_player_position

	$LeavePartnerTriggerArea/LeavePartnerTrigger.target_area = get_node(leave_partner_area_path)
	$LeavePartnerTriggerArea/LeavePartnerTrigger.new_player_position = leave_partner_player_position
