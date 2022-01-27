extends "res://content/trigger/Trigger.gd"

export var target_npc_h: NodePath
export var target_npc_v: NodePath

func trigger():
	.trigger()
#	get_node(target_npc_h).request_state_change('horizontal')
#	get_node(target_npc_v).request_state_change('vertical')
	NewsController.publish_news(
		'Breaking News: The notification Overlay works',
		'We now have push messages in our Game', 
		'happy',
		3
	)
