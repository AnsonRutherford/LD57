class_name MirrorPillar
extends Node

@export var has_mirror := false

@onready var mirror := $Mirror
@onready var interact_collision := $"Interact Collision"

const rotation_duration := 0.1

var rotate_state: int = 0
@export var rotations: Array[Vector3]
	
func _ready() -> void:
	add_to_group("Interactable")
	if has_mirror:
		gain_mirror()
	else:
		lose_mirror()

func lose_mirror():
	has_mirror = false
	mirror.visible = false
	interact_collision.position = Vector3.DOWN / 2

func gain_mirror():
	has_mirror = true
	mirror.visible = true
	interact_collision.position = Vector3.UP / 2

func interact() -> void:
	rotate_state = (rotate_state + 1) % len(rotations)
	create_tween().tween_property(mirror, "rotation", rotations[rotate_state], rotation_duration)
	
func pickup(player: Player) -> void:
	if !has_mirror and player.held_item == Player.HELD_ITEM.MIRROR:
		gain_mirror()
		player.lose_held_item()
	elif has_mirror and player.held_item == Player.HELD_ITEM.NONE:
		lose_mirror()
		player.handle_hold_item(Player.HELD_ITEM.MIRROR)
