extends Node

var active_scene: Node = null

var paused := false
var dialogue := false

var main_menu_scene: PackedScene = preload("res://Scenes/main_menu.tscn")
var gameplay_scene: PackedScene = preload("res://Scenes/gameplay.tscn")

var post_processing: PostProcessing = null

var post_processing_scene: PackedScene = preload("res://Scenes/post_processing.tscn")

enum CURSE {NOT_CURSED, FIRST_LOOP, EXTRA}
var curse_level: CURSE = CURSE.NOT_CURSED
var cycles = 0

var player: Player

var mouse_sens: float = .0025
enum PUZZLE {LIGHT, HOT_COLD, MOON_LIGHT, RAMP_LIGHT, DART, SECRET_DART, CAMO_DART, HOT_COLD_DART_ROOM, FINAL_PUZZLE, NONE}
signal PUZZLE_SOLVED(puzzle: PUZZLE)
signal BOULDER_TRAP
signal PILLAR_INTERACT(pillar: ItemPillar)
signal PILLAR_PICKUP(pillar: ItemPillar)
signal ROTABLE_SWITCH_TOUCHED(id: int, position: int)

signal START_DIALOGUE(speaker: Node3D, text: String)
signal CONTINUE_DIALOGUE(speaker: Node3D, text: String)
signal END_DIALOGUE
signal DIALOGUE_NEXT

signal GAME_PAUSED
signal GAME_UNPAUSED

signal CURSE_LEVEL_CHANGED
signal GHOST_HIT

signal SECRET_NOTE_ACQUIRED(note: SecretNote)
signal NOTE_HOVERED (note_visual: InventoryNoteVisual)

var rot_switch_pos: Dictionary[int, int] = {
	1: 0,
	2: 0,
	3: 0,
	4: 0
}

func _ready() -> void:
	var node = post_processing_scene.instantiate()
	add_child(node)
	post_processing = node.get_child(0)
	load_main_menu()

func toggle_pause() -> void:
	if paused:
		paused = false
		GAME_UNPAUSED.emit()
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	elif !dialogue:
		paused = true
		GAME_PAUSED.emit()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
func load_main_menu() -> void:
	paused = false
	dialogue = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	post_processing.disable_depth_fade()
	_load_scene(main_menu_scene)
	
func load_gameplay() -> void:
	paused = false
	dialogue = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	post_processing.enable_depth_fade()
	_load_scene(gameplay_scene)

func _load_scene(scene: PackedScene) -> void:
	if active_scene != null:
		active_scene.queue_free()
	active_scene = scene.instantiate()
	add_child(active_scene)
	
func change_curse_level(curse: CURSE) -> void:
	curse_level = curse
	CURSE_LEVEL_CHANGED.emit()
	
func start_dialogue(speaker: Node3D, message: String) -> void:
	if paused or dialogue:
		return
	dialogue = true
	START_DIALOGUE.emit(speaker, message)
	
func dialogue_next() -> void:
	if paused or !dialogue:
		return
	DIALOGUE_NEXT.emit()
	
func continue_dialogue(speaker: Node3D, message: String) -> void:
	if paused or !dialogue:
		return
	CONTINUE_DIALOGUE.emit(speaker, message)
	
func end_dialogue() -> void:
	if !dialogue:
		return
	dialogue = false
	END_DIALOGUE.emit()

func check_win_condition(id: int, position: int):
	rot_switch_pos[id] = position
	if rot_switch_pos[1] == 2 && rot_switch_pos[2] == 3 && rot_switch_pos[3] == 2 && rot_switch_pos[4] == 1:
		Globals.PUZZLE_SOLVED.emit(Globals.PUZZLE.FINAL_PUZZLE)
		print("final puzzle solved")
