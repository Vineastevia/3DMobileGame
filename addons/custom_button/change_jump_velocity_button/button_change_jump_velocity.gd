extends StaticBody3D

signal value_changed(delta_value:float)

@export var is_increment: bool = true
@export var min_value: float = 0.0
@export var max_value: float = 20.0
@export var change_rate: float = 0.1 
@export var change_interval: float = 0.1

@onready var animation_player = $AnimationPlayer
@onready var button = $Button/button

var is_in_range: bool = false
var animation_finished: bool = true
var is_button_held: bool = false
var time_since_last_change: float = 0.0

func _ready() -> void:
	button.connect("input_event", _on_button_input_event)
	
	if animation_player:
		animation_player.animation_finished.connect(_on_animation_player_animation_finished)
		
	set_process(false)
	
func _process(delta: float) -> void:
	if is_button_held:
		time_since_last_change += delta
		
		if time_since_last_change >= change_interval:
			time_since_last_change = 0.0
			var delta_value = 0.0
			if is_increment:
				delta_value = change_rate
			else:
				delta_value = - change_rate
			emit_signal("value_changed", delta_value)

func _input(event: InputEvent) -> void:
	if not is_button_held:
		return
	if event is InputEventScreenTouch and not event.pressed:
		_release_button()

func _release_button() -> void:
	is_button_held = false
	set_process(false)
	if animation_player:
		animation_player.play("released")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	animation_finished = true
	
func _on_interaction_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		is_in_range = true

func _on_interaction_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		is_in_range = false

func _on_button_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if not is_in_range:
		return
	else:
		if (event is InputEventScreenTouch and event.pressed):
			if animation_finished:
				animation_finished = false
				is_button_held = true
				set_process(true)
				if animation_player:
					animation_player.play("pressed")
				time_since_last_change = 0.0
