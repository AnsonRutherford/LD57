class_name LightPuzzle
extends Node

var pillar_a: ItemPillar = null
var pillar_b: ItemPillar = null
var pillar_c: ItemPillar = null
var pillar_d: ItemPillar = null
var pillar_e: ItemPillar = null

var solution_pillars: Array[ItemPillar]

@onready var light_beam = $LightBeam

func _ready() -> void:
	Globals.PILLAR_PICKUP.connect(_on_pillar)
	Globals.PILLAR_INTERACT.connect(_on_pillar)
	call_deferred("register_pillars")
	
func _on_pillar(pillar: ItemPillar) -> void:
	if pillar in solution_pillars:
		check_solution()

func register_pillars() -> void:
	pillar_a = ItemPillar.registry["Light Pillar A"]
	pillar_b = ItemPillar.registry["Light Pillar B"]
	pillar_c = ItemPillar.registry["Light Pillar C"]
	pillar_d = ItemPillar.registry["Light Pillar D"]
	pillar_e = ItemPillar.registry["Light Pillar E"]
	solution_pillars = [pillar_a, pillar_b, pillar_c, pillar_d, pillar_e]
	check_solution()

# Hard-coded puzzle solution, yummy
const SOURCE_TO_WALL := 999

func check_solution() -> void:
	pillar_a.light_beam.visible = false
	pillar_b.light_beam.visible = false
	pillar_c.light_beam.visible = false
	pillar_d.light_beam.visible = false
	pillar_e.light_beam.visible = false
	if light_pillar_a():
		light_beam.scale.z = (self.global_position - pillar_a.global_position).length()
	else:
		light_beam.scale.z = SOURCE_TO_WALL

const A_TO_WEST_WALL := 999
const A_TO_EAST_WALL := 999

func light_pillar_a() -> bool:
	if pillar_a.held_item == Player.HELD_ITEM.NONE:
		return false
	if pillar_a.held_item != Player.HELD_ITEM.MIRROR or pillar_a.rotate_state in [2, 3]:
		return true
	pillar_a.light_beam.visible = true
	if pillar_a.rotate_state == 0: # NE
		pillar_a.light_beam.rotation = Vector3(0, -PI/2, -PI/2)
		if light_pillar_d():
			pillar_a.light_beam.scale.z = (pillar_a.global_position - pillar_d.global_position).length()
		else:
			pillar_a.light_beam.scale.z = A_TO_EAST_WALL
	if pillar_a.rotate_state == 1: # NW
		pillar_a.light_beam.rotation = Vector3(-PI/2, -PI, 0)
		if light_pillar_b():
			pillar_a.light_beam.scale.z = (pillar_a.global_position - pillar_b.global_position).length()
		else:
			pillar_a.light_beam.scale.z = A_TO_WEST_WALL
	return true
	
const B_TO_NORTH_WALL := 999
const B_TO_SOUTH_WALL := 999

func light_pillar_b() -> bool:
	if pillar_b.held_item == Player.HELD_ITEM.NONE:
		return false
	if pillar_b.held_item != Player.HELD_ITEM.MIRROR or pillar_b.rotate_state in [1, 2]:
		return true
	pillar_b.light_beam.visible = true
	if pillar_b.rotate_state == 0: # NE
		pillar_b.light_beam.rotation = Vector3(-PI/2, -PI, 0)
		pillar_b.light_beam.scale.z = B_TO_NORTH_WALL
	if pillar_b.rotate_state == 3: # SE
		pillar_b.light_beam.rotation = Vector3(0, -PI/2, -PI/2)
		if light_pillar_c():
			pillar_b.light_beam.scale.z = (pillar_b.global_position - pillar_c.global_position).length()
		else:
			pillar_b.light_beam.scale.z = B_TO_SOUTH_WALL
	return true
	
const C_TO_EAST_WALL = 999
const C_TO_WEST_WALL = 999

func light_pillar_c() -> bool:
	if pillar_c.held_item == Player.HELD_ITEM.NONE:
		return false
	if pillar_c.held_item != Player.HELD_ITEM.MIRROR or pillar_c.rotate_state in [2, 3]:
		return true
	pillar_c.light_beam.visible = true
	if pillar_c.rotate_state == 0: # NE - to Moon Pillar
		pillar_c.light_beam.rotation = Vector3(0, -PI/2, -PI/2)
		if light_moon_pillar():
			pillar_c.light_beam.scale.z = (pillar_c.global_position - pillar_e.global_position).length()
		else:
			pillar_c.light_beam.scale.z = C_TO_EAST_WALL
	if pillar_c.rotate_state == 1: # NW - to Sun Mural
		pillar_c.light_beam.rotation = Vector3(-PI/2, -PI, 0)
		pillar_c.light_beam.scale.z = C_TO_WEST_WALL
		Globals.PUZZLE_SOLVED.emit(Globals.PUZZLE.LIGHT)
	return true
	
const D_TO_NORTH_WALL = 999
const D_TO_SOUTH_WALL = 999
	
func light_pillar_d() -> bool:
	if pillar_d.held_item == Player.HELD_ITEM.NONE:
		return false
	if pillar_d.held_item != Player.HELD_ITEM.MIRROR or pillar_d.rotate_state in [0, 3]:
		return true
	pillar_d.light_beam.visible = true
	if pillar_d.rotate_state == 1: # NW
		pillar_d.light_beam.rotation = Vector3(0, -PI/2, -PI/2)
		pillar_d.light_beam.scale.z = D_TO_NORTH_WALL
	if pillar_d.rotate_state == 2: # SW
		pillar_d.light_beam.rotation = Vector3(-PI/2, -PI, 0)
		pillar_d.light_beam.scale.z = D_TO_SOUTH_WALL
	return true

const MP_TO_NORTH_WALL = 999
const MP_TO_SOUTH_WALL = 999

func light_moon_pillar() -> bool:
	if pillar_e.held_item == Player.HELD_ITEM.NONE:
		return false
	if pillar_e.held_item != Player.HELD_ITEM.MIRROR or pillar_e.rotate_state in [0, 3]:
		return true
	pillar_e.light_beam.visible = true
	if pillar_e.rotate_state == 1: # NW - Moon Mural
		pillar_e.light_beam.rotation = Vector3(0, -PI/2, -PI/2)
		pillar_e.light_beam.scale.z = MP_TO_NORTH_WALL
		Globals.PUZZLE_SOLVED.emit(Globals.PUZZLE.MOON_LIGHT)
	if pillar_e.rotate_state == 2: # SW
		pillar_e.light_beam.rotation = Vector3(-PI/2, -PI, 0)
		pillar_e.light_beam.scale.z = MP_TO_SOUTH_WALL
	return true
	
