extends RigidBody3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	freeze = true
	Globals.BOULDER_TRAP.connect(boulder_fall)

func _physics_process(delta: float) -> void:
	for body: Player in $Area3D.get_overlapping_bodies():
		print("found")
		body.die()

func boulder_fall() -> void:
	print("boulder falling")
	freeze = false
