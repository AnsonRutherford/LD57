class_name SecretNote extends Node3D

var is_found: bool = false

@export var lines: Array[String]
var line_index = 0

func interact() -> void:
	if !is_found:
		print("secret note gained")
		is_found = true
		Globals.SECRET_NOTE_ACQUIRED.emit(self)
		Globals.start_dialogue(self, lines[0])
		line_index += 1
		Globals.DIALOGUE_NEXT.connect(next_line)
		visible = false

func next_line():
	if line_index < len(lines):
		Globals.continue_dialogue(self, lines[line_index])
		line_index += 1
	else:
		Globals.DIALOGUE_NEXT.disconnect(next_line)
		Globals.end_dialogue()
