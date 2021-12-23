extends Node2D

export var frames: SpriteFrames
export var opened: bool

func _ready():
	$AnimatedSprite.frames = frames
	if opened:
		open()
	else:
		close()

func close():
	opened = false
	$AnimatedSprite.animation = "close"
	$TriggerArea.walkable = false

func open():
	opened = true
	$AnimatedSprite.animation = "open"
	$TriggerArea.walkable = true

func trigger():
	if opened:
		close()
	else:
		open()
