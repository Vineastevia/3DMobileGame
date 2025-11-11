extends Node3D

@onready var boutons = [
	$PythonRune,
	$CRune,
	$LuaRune
]

@onready var doorLocked: Node3D = $smallerRoom/wall/wall/DoorPuzzle;

var correct_rune = "PythonRune"
var door_unlocked = false

func _ready():
	$notePython.connect("lettre_lue", _on_lettre_lue)
	$noteC.connect("lettre_lue", _on_lettre_lue)
	$noteLua.connect("lettre_lue", _on_lettre_lue)

	for b in boutons:
		b.visible = false
		b.connect("rune_activated", _on_rune_activated)

func _on_lettre_lue(id):
	var index = id - 1
	if index >= 0 and index < boutons.size():
		print("Lettre", id, "fermée — affichage du bouton correspondant")
		boutons[index].visible = true
	else:
		# Si c’est la 4ᵉ feuille (ou autre), on ne fait rien
		print("Lettre non active, pas de bouton associé :", id)

func _on_rune_activated(rune_name: String) -> void:
	if door_unlocked:
		return  # Already solved
	
	if rune_name == correct_rune:
		print("Correct rune! Opening door...")
		doorLocked.open_door_from_puzzle()
		door_unlocked = true
	else:
		print("Wrong rune:", rune_name, "- Try another one!")
		# Optional: Add visual/audio feedback for wrong choice
		give_wrong_feedback(rune_name)

func give_wrong_feedback(_rune_name: String) -> void:
	# Optional: shake camera, play sound, flash rune, etc.
	print("That's not the right rune!")
