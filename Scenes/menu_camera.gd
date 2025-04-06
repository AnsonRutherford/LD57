extends Camera3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_up"):
		print("p")
		global_position = delta * Vector3(0, 100, 0) + global_position
	
	if Input.is_action_pressed("ui_down"):
		global_position -= delta * Vector3(0, 100, 0)
