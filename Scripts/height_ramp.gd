extends Node3D

var starting_height: Vector3
@export var starting_offset: int
var current_height_idx = 0
const heights: Array[float] = [0, -2, -4]

@export var pillar: String

@onready var rumble_sound: AudioStreamPlayer3D = $AudioStreamPlayer3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	starting_height = global_position
	set_height(starting_offset)
	Globals.PILLAR_PICKUP.connect(_handle_pillar)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_height(new_height_idx) -> void:
	if current_height_idx == new_height_idx:
		return
	current_height_idx = new_height_idx
	var tween = get_tree().create_tween()
	var height = starting_height + Vector3(0, heights[new_height_idx], 0)
	print("new height: ", height)
	tween.tween_property(self, "global_position", height, 3.0)
	rumble_sound.play(16)
	await get_tree().create_timer(3).timeout
	rumble_sound.stop()

func _handle_pillar(touched_pillar: ItemPillar) -> void:
	if touched_pillar.name != pillar:
		return
	match touched_pillar.held_item:
		Player.HELD_ITEM.BLUE_GEM:
			set_height(0)
		Player.HELD_ITEM.GREEN_GEM:
			set_height(1)
		Player.HELD_ITEM.RED_GEM:
			set_height(2)
