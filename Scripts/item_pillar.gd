class_name ItemPillar
extends Node

static var registry: Dictionary[String, ItemPillar] = {}

@export var held_item: Player.HELD_ITEM = Player.HELD_ITEM.NONE
@export var label: String

@onready var light_beam := %LightBeam # Used so Light Puzzle can manipulate it

@onready var items: Dictionary[Player.HELD_ITEM, Node3D] = {
	Player.HELD_ITEM.MIRROR: $Mirror,
	Player.HELD_ITEM.BOULDER_LOOT: $"Boulder Loot",
	Player.HELD_ITEM.HOT_COLD: $HotCold
}

# Rotation
const rotation_duration := 0.1
const angles = [0, PI/2, PI, 3*PI/2]
var rotate_state: int = 0

func _ready() -> void:
	add_to_group("Interactable")
	registry[label] = self
	change_item(held_item)

func change_item(item: Player.HELD_ITEM) -> void:
	if held_item != Player.HELD_ITEM.NONE:
		items[held_item].visible = false
	held_item = item
	if held_item != Player.HELD_ITEM.NONE:
		items[held_item].visible = true
	if held_item == Player.HELD_ITEM.MIRROR:
		rotate_state = 0
		var rotation = Vector3(0, angles[rotate_state], 0)
		create_tween().tween_property(items[held_item], "rotation", rotation, 0)

func interact() -> void:
	if held_item == Player.HELD_ITEM.MIRROR:
		var current_angle = angles[rotate_state]
		rotate_state = (rotate_state + 1) % len(angles)
		var next_angle = angles[rotate_state]
		if next_angle < current_angle:
			next_angle += TAU
		
		var tween = create_tween()
		var rotation = Vector3(0, next_angle, 0)
		tween.tween_property(items[held_item], "rotation", rotation, rotation_duration)
		rotation = Vector3(0, angles[rotate_state], 0)
		tween.tween_property(items[held_item], "rotation", rotation, 0)
	
	Globals.PILLAR_INTERACT.emit(self)
	
func pickup(player: Player) -> void:
	var my_item := held_item
	change_item(player.held_item)
	player.handle_hold_item(my_item)
	Globals.PILLAR_PICKUP.emit(self)
