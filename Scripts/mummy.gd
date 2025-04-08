extends Sprite3D

@onready var area: Area3D = $"Trigger Zone"

var cursed = false
var line_index = 0
var lines = [
	"Trespasser, you foul this sacred tomb!",
	"I curse you to remain here, as you sink deeper towards death.",
	"You will steep in your own avarice and waste away to nothing.",
	"Join those spirits who suffer here forever.",
]

var end_dialogue_line_index = 0
var end_dialogue_lines = [
	"NO! CURSE YOU!",
]

func _ready() -> void:
	Globals.PUZZLE_SOLVED.connect(_puzzle_solved)

func _process(delta: float) -> void:
	if !cursed and area.has_overlapping_bodies():
		cursed = true
		Globals.change_curse_level(Globals.CURSE.FIRST_LOOP)
		Globals.start_dialogue(self, lines[0])
		line_index = 1
		Globals.DIALOGUE_NEXT.connect(next_line)

func next_line() -> void:
	if line_index < len(lines):
		Globals.continue_dialogue(self, lines[line_index])
		line_index += 1
	else:
		Globals.DIALOGUE_NEXT.disconnect(next_line)
		Globals.end_dialogue()
		
func _puzzle_solved(puzzle) -> void:
	if puzzle != Globals.PUZZLE.FINAL_PUZZLE:
		return
	Globals.start_dialogue(self, end_dialogue_lines[0])
	end_dialogue_line_index = 1
	Globals.DIALOGUE_NEXT.connect(end_dialogue_next_line)
	
func end_dialogue_next_line() -> void:
	if end_dialogue_line_index < len(end_dialogue_lines):
		Globals.continue_dialogue(self, end_dialogue_lines[end_dialogue_line_index])
		end_dialogue_line_index += 1
	else:
		Globals.DIALOGUE_NEXT.disconnect(end_dialogue_next_line)
		Globals.end_dialogue()
		Globals.load_credits()
