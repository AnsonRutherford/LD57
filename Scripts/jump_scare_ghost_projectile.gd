class_name GhostProjectile extends Node3D

var velocity: Vector3 = Vector3(0, 0, 1)
var speed: float = 5.0

@onready var area: Area3D = $Area3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite3D.flip_h = randi_range(0, 1) == 1
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Globals.paused || Globals.dialogue:
		return
	if area.has_overlapping_bodies():
		Globals.GHOST_HIT.emit()
		queue_free()
	position += velocity * speed * delta
