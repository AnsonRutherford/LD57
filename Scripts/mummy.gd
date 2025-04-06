extends Sprite3D

@onready var area: Area3D = $"Trigger Zone"

var cursed = false

func _process(delta: float) -> void:
	if !cursed and area.has_overlapping_bodies():
		cursed = true
		Globals.curse_level = Globals.CURSE.FIRST_LOOP
