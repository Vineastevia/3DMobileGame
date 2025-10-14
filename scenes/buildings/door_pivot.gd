extends Node3D
@onready var collider: CollisionShape3D = $CollisionShape3D 

@export var open_angle: float = 90.0        # Angle d’ouverture en degrés
@export var open_speed: float = 2.0         # Vitesse d’ouverture
@export var is_open: bool = false           # État initial de la porte

var target_angle: float = 0.0
var current_angle: float = 0.0
var animating: bool = false

func _ready():
	# Initialise la position selon l'état
	target_angle = open_angle if is_open else 0.0
	current_angle = target_angle
	rotation_degrees.y = current_angle

func _process(delta):
	if animating:
		current_angle = lerp(current_angle, target_angle, delta * open_speed)
		rotation_degrees.y = current_angle
		# Si on est proche de la cible, stoppe l'anim
		if abs(current_angle - target_angle) < 0.5:
			current_angle = target_angle
			animating = false
			if collider:
				collider.disabled = false
				
func interact():
	if animating:
		return 

	is_open = not is_open
	target_angle = open_angle if is_open else 0.0
	animating = true

	print("Porte ", "ouverte" if is_open else "fermée")

	# Désactive temporairement la collision
	if collider:
		collider.disabled = true
 
