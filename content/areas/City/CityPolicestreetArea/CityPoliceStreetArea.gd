extends "res://content/areas/Street.gd"


export (NodePath) var leave_police_area_path
export (Vector2) var leave_police_player_position

func _ready():

	$LeavePoliceTriggerArea/LeavePoliceTrigger.target_area = get_node(leave_police_area_path)
	$LeavePoliceTriggerArea/LeavePoliceTrigger.new_player_position = leave_police_player_position
