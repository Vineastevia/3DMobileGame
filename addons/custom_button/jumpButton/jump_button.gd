extends TouchScreenButton

signal jump_pressed()

func _ready() -> void:
	self.pressed.connect(_on_pressed)

func set_button_visibility(is_enabled: bool) -> void:
	visible = is_enabled

func _on_pressed() -> void:
	jump_pressed.emit()
