extends Node3D

@onready var towards_point = $Marker3D

const SPEED: float = 10.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction: Vector3 = towards_point.global_position - global_position
	position += direction.normalized() * delta * SPEED
