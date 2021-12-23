extends Area2D

export var frames: SpriteFrames
export var opened: bool

func _ready():
	$AnimatedSprite.frames = frames
	if opened:
		open()
	else:
		close()

func close():
	$AnimatedSprite.animation = "close"
	$CollisionShape2D.disabled = false

func open():
	$AnimatedSprite.animation = "open"
	$CollisionShape2D.disabled = true

func trigger():
	if opened:
		close()
	else:
		open()
