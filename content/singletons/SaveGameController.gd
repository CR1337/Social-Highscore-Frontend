extends Node

var autosave_handle: int
var empty: bool
const save_filename = "user://savegame.json"
const default_save_filename = "user://default_savegame.json"

func _persistent_nodes():
	var result = get_tree().get_nodes_in_group("persistent")
	print(result)
	return result
	
func _singletons():
	return [
		CitizenRecord,
		GameStateController,
		# TimeController,
		ViewportManager
	]
	
func _create_file():
	var file = File.new()
	file.open(save_filename, File.WRITE)
	file.store_string(JSON.print({'empty': true}))
	file.close()

func save_game():
	var json_state = {}
	json_state['empty'] = false
	empty = false
	for node in _persistent_nodes():
		json_state[str(node.get_path())] = node.persistent_state()
	for singleton in _singletons():
		json_state[str(singleton.get_path())] = singleton.persistent_state()
	var file = File.new()
	file.open(save_filename, File.WRITE)
	file.store_string(JSON.print(json_state, "    "))
	file.close()

func load_game():
	var file = File.new()
	file.open(save_filename, File.READ)
	var json_state = JSON.parse(file.get_as_text()).result
	file.close()
	if json_state['empty']:
		print("savegame empty")
		file.open(default_save_filename, File.READ)
		json_state = JSON.parse(file.get_as_text()).result
		file.close()
		
	for node in _persistent_nodes():
		node.restore_state(json_state[str(node.get_path())])
	for singleton in _singletons():
		singleton.restore_state(json_state[str(singleton.get_path())])
		
func delete_game():
	var json_state = {}
	json_state['empty'] = true
	empty = true
	var file = File.new()
	file.open(save_filename, File.WRITE)
	file.store_string(JSON.print(json_state, "    "))
	file.close()
		
func _notification(what):
	if what ==  MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		save_game()
		get_tree().quit()
	
func _debug_save_default_game():
	call_deferred("save_game")

func _ready():
	# _debug_save_default_game()
	var file = File.new()
	if not file.file_exists(save_filename):
		_create_file()
	call_deferred("load_game")
	autosave_handle = TimeController.setTimer(60, self)
	
func timer(handle):
	if handle == autosave_handle:
		autosave_handle = TimeController.setTimer(60, self)
		save_game()
