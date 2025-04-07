extends MeshInstance3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Globals.player == null:
		return
	var mat = get_surface_override_material(0)
	mat.albedo_color = Color(1, 1, 1, .5)
