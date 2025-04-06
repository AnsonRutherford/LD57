extends Node3D

@onready var towards_point = $Marker3D
@onready var area = $Area3D

const SPEED: float = 30.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction: Vector3 = towards_point.global_position - global_position
	position += direction.normalized() * delta * SPEED
	rotation.x -= 1.0 * delta
	
	if area.has_overlapping_areas():
		print("dart hit")
		for board in area.get_overlapping_areas():
			board.get_parent().hit()
	if area.has_overlapping_bodies():
		destroy()

func destroy():
	print("dart hit wall")
	queue_free()
