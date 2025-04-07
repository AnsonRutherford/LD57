extends Sprite3D

@onready var area: Area3D = $"Trigger Zone"

var cursed = false
var line_index = 0
var lines = [
	"[wave][color=red]You are now cursed forever!!![/color][/wave]",
	"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
	"okay that's done",
]

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
