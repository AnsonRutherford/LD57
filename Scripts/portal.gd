extends Area3D

var activated := false
@export var fade_out_duration = 1.0
@export var fade_in_duration = 1.0
@export var black_screen_interval = 1.0
@export var teleport_destination: Vector3

func _process(delta: float) -> void:
	if !activated and has_overlapping_bodies():
		activated = true
		var pp_mat = Globals.post_processing
		pp_mat.push_values = true
		var tween = create_tween()
		tween.tween_property(pp_mat, "depth_max", 0, fade_out_duration)
		tween.tween_interval(black_screen_interval)
		tween.tween_property(Globals.player, "global_position", teleport_destination, 0)
		tween.tween_property(pp_mat, "depth_max", 1, fade_in_duration)
		tween.tween_callback(portal_done)

func portal_done() -> void:
	activated = false
	Globals.post_processing.reset()
