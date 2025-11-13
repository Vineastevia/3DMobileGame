extends StaticBody3D

#signal ramassage

@onready var camera = get_viewport().get_camera_3d()
@onready var interaction_area: Area3D = $InteractArea
@onready var open_label: Area3D = $InteractAction

var is_in_range: bool = false

func _ready() -> void:
	var button = get_node("InteractAction")
	button.connect("input_event", _on_InteractAction_input_event)

func _on_interaction_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		is_in_range = true
		print("is in range")

func _on_interaction_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		is_in_range = false
		print("is not in range")

func _on_InteractAction_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	
	if not is_in_range:
		return
	
	if (event is InputEventScreenTouch and event.pressed):
		#ajouter l'emission du signal que les clés sont ramassées
		pass
