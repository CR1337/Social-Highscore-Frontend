extends "res://content/areas/Street.gd"

export (NodePath) var leavePrisonAreaPath
export (Vector2) var leavePrisonPlayerPosition

func _ready():

	$LeavePrisonTrigger.targetArea = get_node(leavePrisonAreaPath)
	$LeavePrisonTrigger.newPlayerPosition = leavePrisonPlayerPosition
