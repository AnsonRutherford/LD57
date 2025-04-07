extends Node

var ghost_scn: PackedScene = preload("res://Scenes/jump_scare_ghost_projectile.tscn")
var ghost_screen_scn: PackedScene = preload("res://Scenes/ghost_screen.tscn")

var time_till_next_ghost: float = 5.0

func _ready() -> void:
	Globals.GHOST_HIT.connect(ghost_hit)

func _process(delta: float) -> void:
	if Globals.curse_level == Globals.CURSE.NOT_CURSED || Globals.dialogue || Globals.paused:
		return
	
	if Globals.player.is_in_treasure_room():
		return
	
	time_till_next_ghost -= delta
	
	if time_till_next_ghost < 0:
		time_till_next_ghost = randi_range(5, 10) if Globals.curse_level == Globals.CURSE.EXTRA else randi_range(20, 25) 
		spawn_ghost()

func spawn_ghost():
	print("spawning ghost")
	var ghost: GhostProjectile = ghost_scn.instantiate()
	add_child(ghost)
	ghost.global_position = get_ghost_position()
	ghost.velocity = (Globals.player.global_position - ghost.global_position).normalized()
	
func ghost_hit():
	print("ghost hit player")
	var ghost = ghost_screen_scn.instantiate()
	add_child(ghost)

func get_ghost_position() -> Vector3:
	var player = Globals.player
	var i: int = 0
	while i < 10:
		i += 1
		player.ghost_rotation.rotate_y(randf_range(0, PI * 2))
		if !player.ghost_ray.is_colliding():
			i = 9999
	return player.ghost_location.global_position
