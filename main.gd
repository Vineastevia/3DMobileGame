extends Node3D

@onready var boutons = [
	$PythonRune,
	$CRune,
	$LuaRune
]

@onready var doorLockedRoom1: Node3D = $smallerRoom/wall/Door1/DoorPuzzle;
@onready var player: CharacterBody3D = $Player
@onready var switch_jump_button: StaticBody3D = $bigRoom/decorations/Switch
@onready var jumping_button: TouchScreenButton = $CanvasLayer/jumpButton

var correct_rune = "PythonRune"
var door_unlocked = false
var keyObtained = false

func _ready():
	$notePython.connect("lettre_lue", _on_lettre_lue)
	$noteC.connect("lettre_lue", _on_lettre_lue)
	$noteLua.connect("lettre_lue", _on_lettre_lue)

	for b in boutons:
		b.visible = false
		b.connect("rune_activated", _on_rune_activated)
		
	switch_jump_button.jump_toggled.connect(_on_jump_toggled)
	jumping_button.jump_pressed.connect(player._on_jump_button_pressed)
	
	jumping_button.visible = false

func _on_lettre_lue(id):
	var index = id - 1
	if index >= 0 and index < boutons.size():
		print("Lettre", id, "fermée — affichage du bouton correspondant")
		boutons[index].visible = true
	else:
		print("Lettre non active, pas de bouton associé :", id)

func _on_rune_activated(rune_name: String) -> void:
	if door_unlocked:
		return
	
	if rune_name == correct_rune:
		doorLockedRoom1.open_door_from_puzzle()
		door_unlocked = true
	else:
		print("Wrong rune:", rune_name)
		give_wrong_feedback(rune_name)

func give_wrong_feedback(_rune_name: String) -> void:
	# Optional: shake camera, play sound, flash rune, etc.
	print("That's not the right rune!")
	
func _on_jump_toggled(enabled: bool) -> void:
	player._on_jump_toggled(enabled)
	jumping_button.visible = enabled
