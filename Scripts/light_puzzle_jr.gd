class_name LightPuzzleJr
extends Node
var my_pillar: ItemPillar = null

@onready var light_beam = $LightBeam

func _ready() -> void:
	Globals.PILLAR_PICKUP.connect(_on_pillar)
	Globals.PILLAR_INTERACT.connect(_on_pillar)
	call_deferred("register_pillars")
	
func _on_pillar(pillar: ItemPillar) -> void:
	if pillar == my_pillar:
		check_solution()

func register_pillars() -> void:
	my_pillar = ItemPillar.registry["Ramp Light Pillar"]
	check_solution()

# Hard-coded puzzle solution, yummy
const SOURCE_TO_WALL := 999

func check_solution() -> void:
	my_pillar.light_beam.visible = false
	if light_my_pillar():
		light_beam.scale.z = (self.global_position - my_pillar.global_position).length()
	else:
		light_beam.scale.z = SOURCE_TO_WALL

const MP_TO_NORTH_WALL := 999
const MP_TO_SOUTH_WALL := 999

func light_my_pillar() -> bool:
	if my_pillar.held_item == Player.HELD_ITEM.NONE:
		return false
	if my_pillar.held_item != Player.HELD_ITEM.MIRROR or my_pillar.rotate_state in [1, 2]:
		return true
	my_pillar.light_beam.visible = true
	if my_pillar.rotate_state == 0: # NE
		my_pillar.light_beam.rotation = Vector3(-PI/2, -PI, 0)
		my_pillar.light_beam.scale.z = MP_TO_NORTH_WALL
		Globals.PUZZLE_SOLVED.emit(Globals.PUZZLE.RAMP_LIGHT)
	if my_pillar.rotate_state == 1: # SE
		my_pillar.light_beam.rotation = Vector3(0, -PI/2, -PI/2)
		my_pillar.light_beam.scale.z = MP_TO_SOUTH_WALL
	return true
	
