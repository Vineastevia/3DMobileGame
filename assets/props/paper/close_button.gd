extends Button

signal close_requested

func _ready():
	self.pressed.connect(_on_close_pressed)

func _on_close_pressed():
	emit_signal("close_requested")
