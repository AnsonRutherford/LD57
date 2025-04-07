class_name SecretNote extends Sprite3D

var is_found: bool = false
@onready var area = $Area3D

@export var puzzle: Globals.PUZZLE
var puzzle_solved = false

@export var lines: Array[String]
var line_index = 0

func _ready() -> void:
	if puzzle == Globals.PUZZLE.NONE:
		puzzle_solved = true
	else:
		Globals.PUZZLE_SOLVED.connect(check_puzzle)
		
func check_puzzle(solved_puzzle: Globals.PUZZLE) -> void:
	if solved_puzzle == puzzle:
		puzzle_solved = true

func _process(_delta) -> void:
	if !is_found and area.has_overlapping_bodies() and puzzle_solved:
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
