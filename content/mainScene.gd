extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	ViewportManager.player = $player
	ViewportManager.currentArea = $Areas/TestArea
	ViewportManager.shaderRect = $ShaderRect
	
	
	ViewportManager.smartphoneMenu = $Overlays/SmartphoneMenu
	ViewportManager.gameMenu = $Overlays/GameMenu
	ViewportManager.transparentOverlay = $Overlays/TransparentOverlay

	ViewportManager.currentOverlay = ViewportManager.transparentOverlay

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
