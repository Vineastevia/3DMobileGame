extends CharacterBody3D

@export var snake_jumping: bool = false
@export var is_demonstration: bool = false

@onready var anim_player: AnimationPlayer = $"Root Scene/AnimationPlayer"
@onready var body: Node3D = $"Root Scene/RootNode/SnakeArmature"

var snake_jumping_velocity: float = 15.0
var jump_timer: float = 0.0
var jump_interval: float = 3.0
var gravity: float = 20.0

func _ready() -> void:
	var anim = anim_player.get_animation("SnakeArmature|Snake_Idle")
	if anim:
		anim.loop_mode = Animation.LOOP_LINEAR
	anim_player.play("SnakeArmature|Snake_Idle")
	
	if is_demonstration:
		create_info_label()
		
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if is_demonstration and snake_jumping:
		jump_timer += delta
		if jump_timer >= jump_interval and is_on_floor():
			perform_jump()
			jump_timer = 0.0
	move_and_slide()

func perform_jump() -> void:
	velocity.y = snake_jumping_velocity
	anim_player.play("SnakeArmature|Snake_Jump")
	
	await anim_player.animation_finished
	if anim_player.current_animation == "SnakeArmature|Snake_Jump":
		anim_player.play("SnakeArmature|Snake_Idle")

func create_info_label() -> void:
	var label = Label3D.new()
	label.text = "snake_jumping = true\nvelocity = %.1f" % snake_jumping_velocity
	label.pixel_size = 0.01
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	label.position = Vector3(0, 5, 0)
	label.modulate = Color.YELLOW
	add_child(label)
	
