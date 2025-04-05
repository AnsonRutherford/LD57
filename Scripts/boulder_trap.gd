class_name BoulderTrap extends Node3D

var is_activated := false

func pickup(player: Player) -> void:
	if !is_activated:
		print("boulder trap activated")
		player.handle_hold_item(Player.HELD_ITEM.BOULDER_LOOT)
		$LootMesh.visible = false
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", self.position + Vector3(0, -2.5, 0), .5)
		Globals.BOULDER_TRAP.emit()
