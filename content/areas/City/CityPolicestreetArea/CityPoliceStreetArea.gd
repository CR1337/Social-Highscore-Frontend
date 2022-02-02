extends "res://content/areas/Street.gd"


export (NodePath) var leave_police_area_path
export (Vector2) var leave_police_player_position

func _ready():

	$LeavePoliceTriggerArea/LeavePoliceTrigger.targetArea = get_node(leave_police_area_path)
	$LeavePoliceTriggerArea/LeavePoliceTrigger.newPlayerPosition = leave_police_player_position
