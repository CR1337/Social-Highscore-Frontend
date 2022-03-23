extends Node

var _autosave_handle = 3 # Stated in default_savegame
var _empty: bool
const _save_filename = "user://savegame.json"
const _default_save_filename = "res://default_savegame.json"

func _persistent_nodes():
	var result = get_tree().get_nodes_in_group("persistent")
	return result

func _singletons():
	return [
		CitizenRecord,
		GameStateController,
		TimeController,
		ViewportManager,
		ImageProcessor,
		NewsController,
		TrafficController
	] + GameStateController.story_controllers.slice(
		1, len(GameStateController.story_controllers) - 1
	)

func _create_file():
	var file = File.new()
	file.open(_save_filename, File.WRITE)
	file.store_string(JSON.print({'empty': true}))
	file.close()

func save_game():
	var json_state = {}
	json_state['empty'] = false
	_empty = false
	for node in _persistent_nodes():
		json_state[str(node.get_path())] = node.persistent_state()
	for singleton in _singletons():
		json_state[str(singleton.get_path())] = singleton.persistent_state()
	var file = File.new()
	file.open(_save_filename, File.WRITE)
	file.store_string(JSON.print(json_state, "    "))
	file.close()

## Debugging
func _save_default_game():
	var json_state = {}
	json_state['empty'] = false
	_empty = false
	for node in _persistent_nodes():
		json_state[str(node.get_path())] = node.persistent_state()
	for singleton in _singletons():
		json_state[str(singleton.get_path())] = singleton.persistent_state()
	var file = File.new()
	file.open(_default_save_filename, File.WRITE)
	file.store_string(JSON.print(json_state, "    "))
	file.close()

func start_new_game():
	GameStateController.deactivate_all_story_controllers()
	ViewportManager.change_to_prolog()
	EventBus.emit_signal("sig_fridge_content_changed")
	
func load_default_game():
	print("savegame empty")
	var file = File.new()
	file.open(_default_save_filename, File.READ)
	call_deferred("start_new_game")
	var json_state = JSON.parse(file.get_as_text()).result
	file.close()
	_restore_states(json_state)

func _restore_states(json_state):
	for node in _persistent_nodes():
		node.restore_state(json_state[str(node.get_path())])
	for singleton in _singletons():
		singleton.restore_state(json_state[str(singleton.get_path())])


func load_game():
	var file = File.new()
	file.open(_save_filename, File.READ)
	var json_state = JSON.parse(file.get_as_text()).result
	file.close()
	if json_state['empty']:
		load_default_game()
		return
	_restore_states(json_state)

func delete_game():
	var json_state = {}
	json_state['empty'] = true
	_empty = true
	var file = File.new()
	file.open(_save_filename, File.WRITE)
	file.store_string(JSON.print(json_state, "    "))
	file.close()

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST or what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		save_game()
		get_tree().quit()

func _debug_save_default_game():
	call_deferred("_save_default_game")
	call_deferred("start_new_game")
	
const _user_directories = [
	"screenshots",
	"news_reactions",
	"authentication_emotions"
]
func _create_directories():
	var dir = Directory.new()
	dir.open("user://")
	for directory in _user_directories:
		if not dir.dir_exists(directory):
			dir.make_dir(directory)

func _ready():
#	_debug_save_default_game()
#	return
	_create_directories()
	var file = File.new()
	if not file.file_exists(_save_filename):
		_create_file()
	_autosave_handle = TimeController.setTimer(60, self, "autosave")
	call_deferred("load_game")


func autosave(handle):
	TimeController.setTimer(60, self, "autosave")
	save_game()
