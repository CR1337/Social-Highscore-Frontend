extends Node

var server_address: String
var server_port: String
var image_rotation_angle: int

const _config_filename = "user://config.json"
var _file: File

var _default_values = {
	'server_address': "78.47.102.251",
	'server_port': "80",
	'image_rotation_angle': 0
}

func _create_file():
	_file.open(_config_filename, File.WRITE)
	_file.store_string(JSON.print(_default_values))
	_file.close()

func _ready():
	_file = File.new()
	if not _file.file_exists(_config_filename):
		_create_file()
	load_from_file()

func store_to_file():
	_file.open(_config_filename, File.WRITE)
	_file.store_string(JSON.print({
		'server_address': server_address,
		'server_port': server_port,
		'image_rotation_angle': image_rotation_angle
	}))
	_file.close()

func load_from_file():
	_file.open(_config_filename, File.READ)
	var content = _file.get_as_text()
	_file.close()
	var json_content = JSON.parse(content).result
	server_address = json_content['serverAddress']
	server_port = json_content['serverPort']
	image_rotation_angle = json_content['imageRotationAngle']
