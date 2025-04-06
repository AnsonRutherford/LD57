class_name PostProcessing
extends MeshInstance3D

@onready var mat := get_surface_override_material(0) as ShaderMaterial
var depth_max = 1.0

var push_values = false

func _process(_delta):
	if push_values:
		mat.set_shader_parameter("depth_max", depth_max)

func reset() -> void:
	push_values = false
	depth_max = 1.0
	mat.set_shader_parameter("depth_max", 1.0)
	
