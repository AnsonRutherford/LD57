extends Node

signal DART_BOARD_HIT(puzzle: Globals.PUZZLE)

const regular_dart_boards: int = 5
var regular_dart_boards_hit: int = 0

const secret_dart_boards: int = 1
var secret_dart_boards_hit: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DART_BOARD_HIT.connect(_dartboard_handle)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _dartboard_handle(puzzle: Globals.PUZZLE) -> void:
	if puzzle == Globals.PUZZLE.DART:
		regular_dart_boards_hit += 1
		print("regular dart boards: ",  regular_dart_boards_hit)
		if regular_dart_boards_hit >= regular_dart_boards:
			print("dart puzzle solved")
			Globals.PUZZLE_SOLVED.emit(Globals.PUZZLE.DART)
	if puzzle == Globals.PUZZLE.SECRET_DART:
		secret_dart_boards_hit += 1
		if secret_dart_boards_hit >= secret_dart_boards:
			print("secret dart puzzle solved")
			Globals.PUZZLE_SOLVED.emit(Globals.PUZZLE.SECRET_DART)
