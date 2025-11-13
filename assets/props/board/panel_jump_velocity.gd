extends Area3D

@onready var sprite: Sprite3D = $Sprite3D
@onready var viewport: SubViewport = $Sprite3D/SubViewport
@onready var spinbox: SpinBox = $Sprite3D/SubViewport/PanelContainer/VBoxContainer/SpinBox
@onready var apply_button: Button = $Sprite3D/SubViewport/PanelContainer/VBoxContainer/CheckButton

var player: CharacterBody3D
var is_interacting: bool = false

func _ready() -> void:
	print("Panel ready - Setting up...")
	
	# Configuration du Sprite3D
	sprite.pixel_size = 0.002
	sprite.billboard = BaseMaterial3D.BILLBOARD_DISABLED
	sprite.no_depth_test = false
	sprite.render_priority = 0
	sprite.texture = viewport.get_texture()
	sprite.centered = true 
	sprite.offset = Vector2.ZERO
	print("Sprite3D configured")
	
	# Configuration du SubViewport
	viewport.size = Vector2i(800, 400)
	viewport.transparent_bg = false
	viewport.gui_disable_input = false
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	
	print("SubViewport size: ", viewport.size)
	print("SubViewport texture: ", viewport.get_texture())
	
	# Configuration du SpinBox
	spinbox.min_value = 0.0
	spinbox.max_value = 20.0
	spinbox.step = 0.5
	spinbox.value = 0.0
	spinbox.suffix = " m/s"
	
	# Active le clavier virtuel pour mobile
	var line_edit = spinbox.get_line_edit()
	if line_edit:
		line_edit.virtual_keyboard_enabled = true
		line_edit.context_menu_enabled = false
		
	# Application automatique quand la valeur change
	spinbox.value_changed.connect(_on_value_changed)
	
	# Bouton d'application
	apply_button.text = "Appliquer"
	apply_button.button_pressed = false
	
	# Connexion des signaux
	apply_button.pressed.connect(_on_apply_pressed)
	input_event.connect(_on_input_event)
	mouse_entered.connect(_on_mouse_entered)
	
	# Trouve le joueur
	player = get_tree().get_first_node_in_group("player")
		
	# Test de visibilité
	sprite.scale = Vector3(2, 2, 2)  # Double la taille pour test
	print("Sprite3D position: ", sprite.global_position)
	print("Sprite3D visible: ", sprite.visible)

func _input(event: InputEvent) -> void:
	# Gère le touch ET la souris (pour tester sur PC)
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		var is_pressed = false
		var touch_position = Vector2.ZERO
		
		if event is InputEventScreenTouch:
			is_pressed = event.pressed
			touch_position = event.position
		elif event is InputEventMouseButton:
			is_pressed = event.pressed and event.button_index == MOUSE_BUTTON_LEFT
			touch_position = event.position
		
		if is_pressed:
			check_touch_on_panel(touch_position)

func check_touch_on_panel(screen_pos: Vector2) -> void:
	# Récupère la caméra
	var camera = get_viewport().get_camera_3d()
	if not camera:
		return
	
	# Raycast depuis la position du touch
	var ray_origin = camera.project_ray_origin(screen_pos)
	var ray_direction = camera.project_ray_normal(screen_pos)
	var ray_end = ray_origin + ray_direction * 100.0
	
	# Effectue le raycast
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	query.collide_with_areas = true  # Important: détecter les Area3D
	query.collide_with_bodies = false
	
	var result = space_state.intersect_ray(query)
	
	# Vérifie si on a touché ce panel
	if result and result.collider == self:
		print("Panel touché!")
		_on_panel_touched(result.position, screen_pos)

func _on_panel_touched(world_pos: Vector3, screen_pos: Vector2) -> void:
	# Convertit la position 3D du touch en position 2D du viewport
	var local_pos = sprite.to_local(world_pos)
	
	# Convertit en coordonnées du viewport (en pixels)
	var viewport_x = (local_pos.x / sprite.pixel_size) + (viewport.size.x / 2.0)
	var viewport_y = (-local_pos.y / sprite.pixel_size) + (viewport.size.y / 2.0)
	var viewport_pos = Vector2(viewport_x, viewport_y)
	
	print("Touch position in viewport: ", viewport_pos)
	
	# Simule un clic sur le SpinBox
	var spinbox_rect = spinbox.get_global_rect()
	if spinbox_rect.has_point(viewport_pos):
		print("SpinBox touché!")
		spinbox.get_line_edit().grab_focus()
		is_interacting = true

func _on_value_changed(value: float) -> void:
	if player and player.has_method("set_jump_velocity"):
		player.set_jump_velocity(value)
	print("Player jump_velocity: ", value)

func _on_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# Focus sur le SpinBox pour permettre l'édition
		spinbox.get_line_edit().grab_focus()

func _on_mouse_entered() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func _on_apply_pressed() -> void:
	if player and player.has_method("set_jump_velocity"):
		player.set_jump_velocity(spinbox.value)
	
	# Feedback visuel
	apply_button.text = "✓ OK"
	await get_tree().create_timer(1.0).timeout
	apply_button.text = "Appliquer"
	
	print("Player jump_velocity: ", spinbox.value)
