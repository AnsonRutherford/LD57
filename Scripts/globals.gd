extends Node

var active_scene: Node = null

var main_menu_scene: PackedScene = preload("res://Scenes/main_menu.tscn")
var gameplay_scene: PackedScene = preload("res://Scenes/gameplay.tscn")

var mouse_sens: float = .01

func _ready() -> void:
	print("debug mode")
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
