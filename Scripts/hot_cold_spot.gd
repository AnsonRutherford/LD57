class_name HotColdSpot extends Node3D

@onready var area: Area3D = $Area3D

@export var puzzle: Globals.PUZZLE = Globals.PUZZLE.HOT_COLD

var is_triggered := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !is_triggered && area.has_overlapping_bodies() && Globals.player.held_item == Player.HELD_ITEM.HOT_COLD:
		print("hot cold spot found")
		is_triggered = true
		Globals.PUZZLE_SOLVED.emit(puzzle)
		area.monitorable = false
		area.monitoring = false
