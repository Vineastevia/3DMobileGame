extends Node3D

signal lettre_lue(id)

@export var letter_mat: StandardMaterial3D

@onready var joystick_layer = get_tree().current_scene.get_node("CanvasLayer")

@onready var ui_letter = get_tree().current_scene.get_node("ui_letter")
@onready var letter2D : TextureRect = ui_letter.get_node("letter")
@onready var close_button = ui_letter.get_node("CloseButton")

@onready var read_label: Area3D = $ButtonAction

var letter_opened: bool = false
var is_in_range: bool = false
var lettre_ouverte_actuellement = null

func _ready() -> void:
	
	read_label.visible = false
	set_material()
	
	ui_letter.visible = false
	
	var button = get_node("ButtonAction")
	button.connect("input_event", _on_ButtonAction_input_event)
	
	close_button.close_requested.connect(_on_close_letter_requested)

func set_material():
	$MeshInstance3D.material_override = letter_mat

func open_letter():
	if lettre_ouverte_actuellement != null:
		return
	lettre_ouverte_actuellement = self
	
	letter2D.texture = letter_mat.albedo_texture
	ui_letter.visible = true
	letter_opened = true
	
	if joystick_layer:
		joystick_layer.visible = false
		
func _on_close_letter_requested():
	close_letter()
	
func close_letter():
	if lettre_ouverte_actuellement != self:
		return
	lettre_ouverte_actuellement = null
	
	ui_letter.visible = false
	letter_opened = false
	if joystick_layer:
		joystick_layer.visible = true

	var id: int = 0;

	match get_name():
		"notePython":
			id = 1
		"noteC":
			id = 2
		"noteLua": 
			id = 3
		_: 
			id = -1
	if id > 0:
		emit_signal("lettre_lue", id)

func _on_interaction_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and not letter_opened:
		is_in_range = true
		read_label.visible = true

func _on_interaction_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		is_in_range = false
		read_label.visible = false

func _on_ButtonAction_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if not is_in_range:
		return
	
	if (event is InputEventScreenTouch and event.pressed):
		if not letter_opened:
			open_letter()
