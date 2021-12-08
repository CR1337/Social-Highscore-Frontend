extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var http_request

# Called when the node enters the scene tree for the first time.
func _ready():
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", self, "_on_request_completed")


func trigger():
	#var error = http_request.request("http://78.47.102.251:80/analyze", [], false, HTTPClient.METHOD_POST, to_json({'img':' , '}))
	EventBus.emit_signal("take_face_and_analyze")
func _on_request_completed(result, response_code, headers, body):
	print("Success")
