extends Area3D

@onready var sprite: Sprite3D = $Sprite3D
@onready var viewport: SubViewport = $Sprite3D/SubViewport
@onready var check_button: CheckBox = $Sprite3D/SubViewport/PanelContainer/VBoxContainer/CheckBox

var player: CharacterBody3D

func _ready() -> void:
	# Configuration du Sprite3D
	sprite.pixel_size = 0.002
	sprite.billboard = BaseMaterial3D.BILLBOARD_DISABLED
	sprite.texture = viewport.get_texture()
	
	# Configuration du SubViewport
	viewport.size = Vector2i(400, 200)
	viewport.transparent_bg = true
	viewport.gui_disable_input = false
	
	# Texte du CheckButton
	check_button.text = "Activer"
	check_button.button_pressed = false
	
	# Connexion du signal
	check_button.toggled.connect(_on_check_toggled)
	input_event.connect(_on_input_event)
	mouse_entered.connect(_on_mouse_entered)
	
	# Trouve le joueur
	player = get_tree().get_first_node_in_group("player")
	if not player:
		push_warning("Player not found! Add player to 'player' group")

func _on_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# Toggle le CheckButton
		check_button.button_pressed = !check_button.button_pressed

func _on_mouse_entered() -> void:
	# Change le curseur pour indiquer l'interactivité
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func _on_check_toggled(toggled_on: bool) -> void:
	if player and player.has_method("set_jump_enabled"):
		player.set_jump_enabled(toggled_on)
	print("Player can_jump: ", toggled_on)
