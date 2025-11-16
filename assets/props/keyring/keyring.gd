extends StaticBody3D

signal keyring_picked_up

@onready var pick_up_label = $InteractAction/Label3D
@onready var interaction_area = $InteractArea

var is_in_range: bool = false

func _ready() -> void:
	pick_up_label.visible = false
	
	var button = get_node("InteractAction")
	button.connect("input_event", _on_interact_action_input_event)
	
	interaction_area.body_entered.connect(_on_interaction_area_body_entered)
	interaction_area.body_exited.connect(_on_interaction_area_body_exited)

func _on_interaction_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		is_in_range = true
		pick_up_label.visible = true

func _on_interaction_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		is_in_range = false
		pick_up_label.visible = false

func _on_interact_action_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	
	if not is_in_range:
		return
	
	if (event is InputEventScreenTouch and event.pressed):
		emit_signal("keyring_picked_up")
		queue_free()
