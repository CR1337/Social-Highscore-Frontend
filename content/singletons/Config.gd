extends Node

var serverAddress: String
var serverPort: String
var imageRotationAngle: int

var configFilename = "user://config.json"
var file: File

var defaultValues = {
	'serverAddress': "78.47.102.251",
	'serverPort': "80",
	'imageRotationAngle': 0
}

func _create_file():
	file.open(configFilename, File.WRITE)
	file.store_string(JSON.print(defaultValues))
	file.close()

func _ready():
	file = File.new()
	if not file.file_exists(configFilename):
		_create_file()
	load_from_file()

func store_to_file():
	file.open(configFilename, File.WRITE)
	file.store_string(JSON.print({
		'serverAddress': serverAddress,
		'serverPort': serverPort,
		'imageRotationAngle': imageRotationAngle
	}))
	file.close()
	
func load_from_file():
	file.open(configFilename, File.READ)
	var content = file.get_as_text()
	file.close()
	var json_content = JSON.parse(content).result
	serverAddress = json_content['serverAddress']
	serverPort = json_content['serverPort']
	imageRotationAngle = json_content['imageRotationAngle']
