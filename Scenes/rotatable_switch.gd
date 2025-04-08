extends Node3D

@export var id: int = -1
@export var texture: Texture2D = null
var current_rotation: int = 0
@onready var sprite: Sprite3D = $Sprite3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.texture = texture


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func interact() -> void:
	increment_rotation()
	sprite.rotate_z(PI / 2)
	print("rotation now is: ", current_rotation)
	Globals.check_win_condition(id, current_rotation)
	$AudioStreamPlayer3D.play(25.2)
	await get_tree().create_timer(.5).timeout
	$AudioStreamPlayer3D.stop()

func increment_rotation() -> void:
	current_rotation = 0 if current_rotation > 2 else current_rotation + 1
