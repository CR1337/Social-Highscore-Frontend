extends Node

export var id: String

var _blocked = false
var _block_state = "blocked"
export var blocked_dialog_filename: String

func persistent_state():
	return {
		'blocked': _blocked,
		'block_state': _block_state
	}
	
func restore_state(state):
	_blocked = state['blocked']
	_block_state = state['block_state']

func _ready():
	add_to_group("persistent")
	EventBus.connect("sig_trigger", self, "_on_trigger")

func _on_trigger(trigger_id, kwargs):
	if trigger_id != id:
		return
		
	if trigger_id == "tid_living_busstreet_bus":
		print("")
		
	if kwargs.get('action') == 'block':
		_blocked = true
		if kwargs.has('block_state'):
			_block_state = kwargs["block_state"]
		else: 
			_block_state = "blocked"
	elif kwargs.get('action') == 'unblock':
		_blocked = false
	else:
		trigger(kwargs)

func trigger(kwargs):
	pass
	# for debugging
	# print(id)

