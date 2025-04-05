extends Node3D

@export var puzzle: Globals.PUZZLE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$OmniLight3D.visible = false
	Globals.PUZZLE_SOLVED.connect(_handle_puzzle_solved)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _handle_puzzle_solved(puzzle_solved: Globals.PUZZLE) -> void:
	if puzzle_solved == puzzle:
		$OmniLight3D.visible = true
