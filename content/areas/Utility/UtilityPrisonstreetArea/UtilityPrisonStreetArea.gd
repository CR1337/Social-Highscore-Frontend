extends "res://content/areas/Street.gd"

export (NodePath) var leave_prison_area_path
export (Vector2) var leave_prison_player_position

func _ready():

	$LeavePrisonTriggerArea/LeavePrisonTrigger.targetArea = get_node(leave_prison_area_path)
	$LeavePrisonTriggerArea/LeavePrisonTrigger.newPlayerPosition = leave_prison_player_position
