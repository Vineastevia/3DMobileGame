extends Area3D

@export var open_rotation = Vector3(0, 90, 0)
@export var closed_rotation = Vector3.ZERO
@export var speed = 3.0

var is_open = false
var t = 0.0

func interact():
	is_open = !is_open

func _process(delta):
	t = move_toward(t, 1.0 if is_open else 0.0, delta * speed)
	rotation_degrees = closed_rotation.lerp(open_rotation, t)
