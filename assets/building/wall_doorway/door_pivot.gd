extends Node3D

@export var requires_puzzle: bool = false
@export var requires_keyrings: bool = false

@onready var animation = $AnimationPlayer
@onready var open_label: Area3D = $ButtonAction

var animation_finished: bool = true
var is_in_range: bool = false
var door_open: bool = false
var has_keyrings: bool = false

func _ready() -> void:
	open_label.visible = false
	
	var button = get_node("ButtonAction")
	button.connect("input_event", _on_ButtonAction_input_event)

func open_door_from_puzzle() -> void:
	if requires_puzzle and not door_open:
		animation.play("DoorOpen")
		door_open = true

func unlock_with_keyrings() -> void:
	has_keyrings = true
	print("Door unlocked with keyrings!")
		
func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	animation_finished = true

func _on_interaction_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and not door_open and not requires_puzzle:
		is_in_range = true
		if requires_keyrings:
			open_label.visible = has_keyrings
		else:
			open_label.visible = true

func _on_interaction_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		is_in_range = false
		open_label.visible = false

func _on_ButtonAction_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if not is_in_range:
		return
		
	if requires_keyrings and not has_keyrings:
		return
		
	if (event is InputEventScreenTouch and event.pressed):
		if animation_finished:
			animation_finished = false
			if not door_open:
				animation.play("DoorOpen")
			else:
				animation.play("DoorClose")
			door_open = not door_open
