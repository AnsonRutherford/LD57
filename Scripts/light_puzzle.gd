class_name LightPuzzle
extends Node

static var instance: LightPuzzle = null
static var pillars: Dictionary[MirrorPillar.PILLAR_INDEX, MirrorPillar] = {}

@export var solution: Array[int]

@onready var light_beam = $LightBeam

func _ready() -> void:
	instance = self

static func register_pillar(pillar: MirrorPillar) -> void:
	pillars[pillar.pillar_index] = pillar

static func check_solution() -> void:
	var pillar1 = pillars[MirrorPillar.PILLAR_INDEX.PILLAR1]
	if !pillar1.has_mirror:
		instance.light_beam.scale.z = 28
	else:
		instance.light_beam.scale.z = 7
		pillar1.light_beam.scale.z = 0.1
		if pillar1.rotate_state == 1:
			pillar1.light_beam.scale.z = 3
		if pillar1.rotate_state == 3:
			pillar1.light_beam.scale.z = 3
			Globals.PUZZLE_SOLVED.emit(Globals.PUZZLE.LIGHT)
