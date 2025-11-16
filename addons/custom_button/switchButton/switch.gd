extends StaticBody3D

signal jump_toggled(enabled: bool)
signal set_velocity(jump_force: float)

@onready var animation_player = $AnimationPlayer
@onready var button = $switch/Button

var is_in_range: bool = false
var animation_finished: bool = true
var is_toggled: bool = false
 
func _ready() -> void:
	button.connect("input_event", _on_Button_input_event)

func _on_interaction_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		is_in_range = true
		
func _on_interaction_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		is_in_range = false

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	animation_finished = true
	
func _on_Button_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if not is_in_range:
		return
	else:
		if (event is InputEventScreenTouch and event.pressed):
			if animation_finished:
				animation_finished = false
				is_toggled = !is_toggled
				
				if is_toggled:
					animation_player.play("Slide-True") 
				else:
					animation_player.play("Slide-False")
					
				jump_toggled.emit(is_toggled)
