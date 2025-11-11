extends Node3D

@export var snake_jumping: bool = false

@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	var anim = anim_player.get_animation("SnakeArmature|Snake_Idle")
	if anim:
		anim.loop_mode = Animation.LOOP_LINEAR
	anim_player.play("SnakeArmature|Snake_Idle")
