extends Node3D

@onready var mesh = $MeshInstance3D
@onready var body = $StaticBody3D

@export var lines: Array[String]
var line_index = 0

func _ready() -> void:
	Globals.CURSE_LEVEL_CHANGED.connect(_on_curse_level_changed)
	mesh.visible = false
	body.process_mode = PROCESS_MODE_DISABLED

func interact() -> void:
	Globals.start_dialogue(self, lines[0])
	line_index += 1
	Globals.DIALOGUE_NEXT.connect(next_line)
	
func next_line() -> void:
	if line_index < len(lines):
		Globals.continue_dialogue(self, lines[line_index])
		line_index += 1
	else:
		Globals.DIALOGUE_NEXT.disconnect(next_line)
		Globals.end_dialogue()
	
func _on_curse_level_changed() -> void:
	if Globals.curse_level == Globals.CURSE.NOT_CURSED:
		mesh.visible = false
		body.process_mode = PROCESS_MODE_DISABLED
	else:
		mesh.visible = true
		body.process_mode = PROCESS_MODE_INHERIT
