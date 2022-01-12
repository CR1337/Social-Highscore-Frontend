extends Node

onready var transparentOverlay = get_node("/root/mainScene/Overlays/TransparentOverlay")

var player: Node2D
onready var currentArea = get_node("/root/mainScene/Areas/LivingHomestreetArea")
var shaderRect: ColorRect
onready var currentOverlay = transparentOverlay
onready var lastOverlay = transparentOverlay

var smartphoneMenu: Node2D
var gameMenu: Node2D
var configMenu: Node2D
var referenceImageMenu: Node2D
var dialogOverlay: Node2D

var newsApp: Node2D
var messengerApp: Node2D
var bankingApp: Node2D
var citizenApp: Node2D
var authenticationOverlay: Node2D

func persistent_state():
	return {
		'current_area': currentArea.get_path(),
		'current_overlay': currentOverlay.get_path(),
		'last_overlay': lastOverlay.get_path()
	}
	
func restore_state(state):
	var new_current_area = get_node(state['current_area'])
	
	var tmp_position = new_current_area.position
	new_current_area.position = currentArea.position
	currentArea.position = tmp_position
	
	currentArea = new_current_area
	
	change_overlay(get_node(state['current_overlay']))
	lastOverlay = get_node(state['last_overlay'])

func _ready():
	InputBus.connect("phone_pressed", self, "_on_phone_pressed")
	InputBus.connect("menu_pressed", self, "_on_menu_pressed")
	# lastOverlay = transparentOverlay
	
func _on_phone_pressed():
	change_overlay(smartphoneMenu)
	
func _on_menu_pressed():
	change_overlay(gameMenu)
	
func change_to_transparent():
	change_overlay(transparentOverlay)
	
func change_to_config():
	change_overlay(configMenu)
	
func change_to_refenreceImage():
	change_overlay(referenceImageMenu)
	
func change_to_last():
	change_overlay(lastOverlay)
	
func change_to_dialog(json_filename, state):
	dialogOverlay.initialize(json_filename, state)
	change_overlay(dialogOverlay)
	
func change_to_authentication(post_authentication_trigger):
	authenticationOverlay.post_authentication_trigger = post_authentication_trigger
	change_overlay(authenticationOverlay)

func change_area(targetArea, newPlayerPosition):
	shaderRect.cover()
	if currentArea.get('active') != null:
		currentArea.active = false
	if targetArea.get('active') != null:
		targetArea.active = true
	var tmp_position = targetArea.position
	targetArea.position = currentArea.position
	currentArea.position = tmp_position
	currentArea = targetArea
	
	if newPlayerPosition.y >= 0: 
		player.position.y = (newPlayerPosition.y - 0.5) * Globals.tile_size
	if newPlayerPosition.x >= 0: 
		player.position.x = (newPlayerPosition.x - 0.5) * Globals.tile_size
	shaderRect.area_change()
	
func change_overlay(targetOverlay):
	var tmp_position = targetOverlay.position
	targetOverlay.position = currentOverlay.position
	currentOverlay.position = tmp_position
	lastOverlay = currentOverlay
	currentOverlay = targetOverlay
