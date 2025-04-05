extends MeshInstance3D

const rotation_duration := 0.1

var rotate_state: int = 0
@export var rotations: Array[Vector3]

func interact() -> void:
	rotate_state = (rotate_state + 1) % len(rotations)
	var look_vector := rotations[rotate_state].normalized()
	create_tween().tween_property(self, "rotation", look_vector, rotation_duration)
	
func _ready() -> void:
	add_to_group("Interactable")
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_up"):
		interact()
	
