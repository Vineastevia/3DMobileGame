extends Node3D

@onready var animation = $AnimationPlayer
@onready var interaction_area: Area3D = $InteractionArea
@onready var open_label: Area3D = $ButtonAction

var animation_finished: bool = true
var is_in_range: bool = false
var door_open: bool = false

func _ready() -> void:
	open_label.visible = false
	var button = get_node("ButtonAction")
	button.connect("input_event", _on_ButtonAction_input_event)

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	animation_finished = true

func _on_interaction_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and not door_open:
		is_in_range = true
		open_label.visible = true

func _on_interaction_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		is_in_range = false
		open_label.visible = false

func _on_ButtonAction_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	print("dans input_event")
	if not is_in_range:
		return

	if (event is InputEventScreenTouch and event.pressed):
		print("toucher détecté sur la porte")
		if animation_finished:
			animation_finished = false
			if not door_open:
				animation.play("DoorOpen")
				
			else:
				animation.play("DoorClose")
			
			door_open = not door_open
