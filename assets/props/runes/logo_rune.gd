extends Node3D

signal rune_activated(rune_name: String) 

@export var letter_mat: StandardMaterial3D

@onready var animation = $AnimationPlayer

var animation_finished: bool = true
var is_in_range: bool = false
var is_activated: bool = false

func set_material():
	$MeshInstance3D.material_override = letter_mat

func _ready() -> void:
	set_material()
	var button = get_node("ButtonAction")
	button.connect("input_event", _on_ButtonAction_input_event)

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	animation_finished = true


func _on_interaction_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		is_in_range = true


func _on_interaction_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		is_in_range = false
	
func _on_ButtonAction_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	
	if not is_in_range or is_activated:
		return
	
	if (event is InputEventScreenTouch and event.pressed):
		
		if animation_finished:
			animation_finished = false
			animation.play("Click")
			is_activated = true
			rune_activated.emit(name)
