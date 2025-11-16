extends Node

@onready var boards_data = $GetBoardsData
@onready var introduction_data = $GetIntroductionData
@onready var loops_data= $GetLoopsData

func _ready():
	boards_data.request_completed.connect(_on_request_completed)
	boards_data.request("http://localhost:8080/learning/boards")
	print("Fetch data from server for : boards")
	
	introduction_data.request_completed.connect(_on_request_completed)
	introduction_data.request("http://localhost:8080/learning/introduction")
	print("Fetch data from server for : introduction")
	
	loops_data.request_completed.connect(_on_request_completed)
	loops_data.request("http://localhost:8080/learning/loops")
	print("Fetch data from server for : loops")

func _on_request_completed(_result, _response_code, _headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	print(json)
