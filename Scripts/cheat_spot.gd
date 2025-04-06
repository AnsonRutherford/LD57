extends Node3D

@export var action: String

func _process(_delta) -> void:
	if Input.is_action_just_released(action):
		Globals.player.global_position = self.global_position
