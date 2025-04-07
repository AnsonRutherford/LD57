extends Node3D

@onready var visual = $Visual
@onready var body = $StaticBody3D
@onready var eye_contact = $EyeContact

@export var lines: Array[String]
var line_index = 0

func _ready() -> void:
	Globals.CURSE_LEVEL_CHANGED.connect(_on_curse_level_changed)
	visual.visible = false
	body.process_mode = PROCESS_MODE_DISABLED
	
func _process(_delta) -> void:
	var pos = Globals.player.global_position
	pos.y = global_position.y
	# look_at(pos)

func interact() -> void:
	Globals.start_dialogue(eye_contact, lines[0])
	line_index += 1
	Globals.DIALOGUE_NEXT.connect(next_line)
	
func next_line() -> void:
	if line_index < len(lines):
		Globals.continue_dialogue(eye_contact, lines[line_index])
		line_index += 1
	else:
		Globals.DIALOGUE_NEXT.disconnect(next_line)
		Globals.end_dialogue()
	
func _on_curse_level_changed() -> void:
	if Globals.curse_level == Globals.CURSE.NOT_CURSED:
		visual.visible = false
		body.process_mode = PROCESS_MODE_DISABLED
	else:
		visual.visible = true
		body.process_mode = PROCESS_MODE_INHERIT
