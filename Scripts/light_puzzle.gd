class_name LightPuzzle
extends Node

static var instance: LightPuzzle = null
static var pillars: Dictionary[MirrorPillar.PILLAR_INDEX, MirrorPillar] = {}

@export var solution: Array[int]

func _ready() -> void:
	instance = self

static func register_pillar(pillar: MirrorPillar) -> void:
	pillars[pillar.pillar_index] = pillar

static func check_solution() -> void:
	var pillar1 = pillars[MirrorPillar.PILLAR_INDEX.PILLAR1]
	if pillar1.has_mirror and pillar1.rotate_state == 3:
		Globals.PUZZLE_SOLVED.emit(Globals.PUZZLE.LIGHT) 
