extends Node3D

@export var puzzle: Globals.PUZZLE

var is_open: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.PUZZLE_SOLVED.connect(_puzzle_solved)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func open() -> void:
	if is_open:
		return
	is_open = true
	print("opening puzzle door")
	# tween for now, could make this animation player if we need more advanced movement
	var tween := get_tree().create_tween()
	tween.tween_property(self, "position", self.position + Vector3(0, 5, 0), 1.0)
	$AudioStreamPlayer3D.play(14.0)
	await get_tree().create_timer(1).timeout
	$AudioStreamPlayer3D.stop()

func _puzzle_solved(puzzle_solved: Globals.PUZZLE) -> void:
	if puzzle_solved == puzzle:
		open()
