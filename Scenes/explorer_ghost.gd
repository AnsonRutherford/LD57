extends Sprite3D

const first_lines: Array[String] = ["Hey buddy, that guy is a jerk.\nI can help you by making the curse stronger, and allowing you to see ghosts.", "My friends will help you, but other ghosts will attack you in greater number. If you want to try to figure things out alone, that's safer.", "Talk to me again if you wish to get REALLY cursed"]
const uncursed_lines: Array[String] = ["There, I increased your curse power", "My friends can now help you, but you will be hunted.", "Talk to me again if it's too much."]
const cursed_lines: Array[String] = ["Had too much, eh?", "You won't be able to see my friends anymore, but less ghosts will attack you", "Talk to me again if you want to get my friends help again."]

var talked_to_yet: bool = false
var line_index = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func interact():
	var lines: Array[String]
	if !talked_to_yet:
		lines = first_lines
	elif Globals.curse_level == Globals.CURSE.FIRST_LOOP:
		lines = uncursed_lines
		Globals.change_curse_level(Globals.CURSE.EXTRA)
	else:
		lines = cursed_lines
		Globals.change_curse_level(Globals.CURSE.FIRST_LOOP)
	line_index = 1
	Globals.start_dialogue(self, lines[0])
	Globals.DIALOGUE_NEXT.connect(next_line)

func next_line() -> void:
	var lines: Array[String]
	if !talked_to_yet:
		lines = first_lines
	elif Globals.curse_level == Globals.CURSE.FIRST_LOOP:
		lines = cursed_lines
	else:
		lines = uncursed_lines
	if line_index < len(lines):
		Globals.continue_dialogue(self, lines[line_index])
		line_index += 1
	else:
		Globals.DIALOGUE_NEXT.disconnect(next_line)
		talked_to_yet = true
		Globals.end_dialogue()
