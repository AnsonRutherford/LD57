extends Node

var active_scene: Node = null

var main_menu_scene: PackedScene = preload("res://Scenes/main_menu.tscn")
var gameplay_scene: PackedScene = preload("res://Scenes/gameplay.tscn")

var post_processing: PostProcessing = null

var post_processing_scene: PackedScene = preload("res://Scenes/post_processing.tscn")


var player: Player

var mouse_sens: float = .0025
enum PUZZLE {LIGHT, HOT_COLD, MOON_LIGHT, RAMP_LIGHT}
signal PUZZLE_SOLVED(puzzle: PUZZLE)
signal BOULDER_TRAP
signal PILLAR_INTERACT(pillar: ItemPillar)
signal PILLAR_PICKUP(pillar: ItemPillar)

func _ready() -> void:
	var node = post_processing_scene.instantiate()
	add_child(node)
	post_processing = node.get_child(0)
	load_main_menu()
	
func load_main_menu() -> void:
	_load_scene(main_menu_scene)
	
func load_gameplay() -> void:
	_load_scene(gameplay_scene)

func _load_scene(scene: PackedScene) -> void:
	if active_scene != null:
		active_scene.queue_free()
	active_scene = scene.instantiate()
	add_child(active_scene)
