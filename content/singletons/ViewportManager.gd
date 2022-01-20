extends Node

onready var player = get_node("/root/mainScene/player")
onready var shaderRect = get_node("/root/mainScene/ShaderRectNode2D/ShaderRect")

onready var transparentOverlay = get_node("/root/mainScene/Overlays/TransparentOverlay")
onready var smartphoneMenu = get_node("/root/mainScene/Overlays/SmartphoneMenu")
onready var gameMenu = get_node("/root/mainScene/Overlays/GameMenu")
onready var configMenu = get_node("/root/mainScene/Overlays/ConfigMenu")
onready var referenceImageMenu = get_node("/root/mainScene/Overlays/ReferenceImageMenu")
onready var dialogOverlay = get_node("/root/mainScene/Overlays/DialogOverlay")
onready var authenticationOverlay = get_node("/root/mainScene/Overlays/AuthenticationOverlay")

onready var messenger_contacts_overlay = get_node("/root/mainScene/Overlays/MessengerAppContacts")
onready var messenger_messages_overlay = get_node("/root/mainScene/Overlays/MessengerAppMessages")


onready var newsApp: Node2D
onready var messengerApp: Node2D
onready var bankingApp: Node2D
onready var citizenApp: Node2D

onready var currentArea = get_node("/root/mainScene/Areas/LivingHomestreetArea")
onready var currentOverlay = transparentOverlay
onready var lastOverlay = transparentOverlay

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
	change_to_smartphone()
	
func _on_menu_pressed():
	change_overlay(gameMenu)
	
func change_to_transparent():
	change_overlay(transparentOverlay)
	
func change_to_config():
	change_overlay(configMenu)
	
func change_to_refenreceImage():
	change_overlay(referenceImageMenu)

func change_to_messenger_contacts():
	change_overlay(messenger_contacts_overlay)

func change_to_smartphone():
	change_overlay(smartphoneMenu)
	
func change_to_messenger_messages(contact):
	messenger_messages_overlay.set_current_contact(contact)
	messenger_messages_overlay.show()
	change_overlay(messenger_messages_overlay)
	
func change_to_last():
	change_overlay(lastOverlay)
	
func change_to_dialog(json_filename, state):
	dialogOverlay.initialize(json_filename, state)
	change_overlay(dialogOverlay)
	
func change_to_authentication(post_authentication_trigger_id):
	authenticationOverlay.post_authentication_trigger_id = post_authentication_trigger_id
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
