class_name LightPuzzle
extends Node

static var instance: LightPuzzle = null

@export var solution: Array[int]
const solution_pillars := ["Pillar 1"]

@onready var light_beam = $LightBeam

func _ready() -> void:
	instance = self
	Globals.PILLAR_PICKUP.connect(_on_pillar)
	Globals.PILLAR_INTERACT.connect(_on_pillar)
	
func _on_pillar(pillar: ItemPillar) -> void:
	if pillar.label in solution_pillars:
		check_solution()

func check_solution() -> void:
	var pillar1 = ItemPillar.registry["Pillar 1"]
	if !pillar1.held_item == Player.HELD_ITEM.MIRROR:
		instance.light_beam.scale.z = 28
	else:
		instance.light_beam.scale.z = 7
		pillar1.light_beam.scale.z = 0.1
		if pillar1.rotate_state == 1:
			pillar1.light_beam.scale.z = 3
		if pillar1.rotate_state == 3:
			pillar1.light_beam.scale.z = 3
			Globals.PUZZLE_SOLVED.emit(Globals.PUZZLE.LIGHT)
