class_name DialogueCamera
extends Camera3D

static var instance: DialogueCamera

func _ready() -> void:
	instance = self
	Globals.START_DIALOGUE.connect(_on_start_dialogue)
	
func _on_start_dialogue(speaker: Node3D, _message: String) -> void:
	make_current()
	global_position = Globals.player.camera.global_position
	look_at(speaker.global_position)
	var look_rotation = global_rotation
	rotation = Globals.player.camera.global_rotation
	create_tween().tween_property(self, "global_rotation", look_rotation, 0.5)
	
