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
	var button_type = "INCREMENT" if is_increment else "DECREMENT"
	print("[", button_type, "] READY - animation_finished:", animation_finished)
	
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
	
	var button_type = "INCREMENT" if is_increment else "DECREMENT"
	
	if event is InputEventScreenTouch and not event.pressed:
		print("[", button_type, "] Touch RELEASED detected")
		_release_button()

func _release_button() -> void:
	var button_type = "INCREMENT" if is_increment else "DECREMENT"
	print("[", button_type, "] _release_button called")
	
	is_button_held = false
	set_process(false)
	if animation_player:
		print("[", button_type, "] Playing 'released' animation")
		animation_player.play("released")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	var button_type = "INCREMENT" if is_increment else "DECREMENT"
	print("[", button_type, "] Animation '", anim_name, "' FINISHED")
	animation_finished = true
	print("[", button_type, "] animation_finished set to TRUE")
	
func _on_interaction_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		is_in_range = true

func _on_interaction_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		is_in_range = false

func _on_button_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	var button_type = "INCREMENT" if is_increment else "DECREMENT"
	
	if not is_in_range:
		return
	else:
		if (event is InputEventScreenTouch and event.pressed):
			print("[", button_type, "] Touch PRESSED - animation_finished:", animation_finished)
			if animation_finished:
				print("[", button_type, "] ACCEPTED - Starting press")
				animation_finished = false
				is_button_held = true
				set_process(true)
				if animation_player:
					print("[", button_type, "] Playing 'pressed' animation")
					animation_player.play("pressed")
				time_since_last_change = 0.0
