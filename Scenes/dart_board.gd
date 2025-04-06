extends Node3D

var is_hit := false
@export var puzzle: Globals.PUZZLE = Globals.PUZZLE.DART

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func hit():
	if is_hit:
		return
	print("dartboard is hit")
	is_hit = true
	$Sprite3D.modulate = Color(1, 1, 1, 0.3)
	DartHandling.DART_BOARD_HIT.emit(puzzle)
