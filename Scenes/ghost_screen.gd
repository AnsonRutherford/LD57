extends Node2D

var time_left: float = 3.0

@onready var sprite: Sprite2D = $Sprite2D

var base_pos: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	base_pos = get_viewport_rect().size / 2
	sprite.modulate = Color(1, 1, 1, 0)
	var tween = create_tween()
	tween.tween_property(sprite, "modulate", Color(1, 1, 1, 1), 1.5)
	tween.tween_property(sprite, "modulate", Color(1, 1, 1, 0), 1.5)
	
	$AudioStreamPlayer.play(.7)
	
	#var skew_tween = create_tween()
	#skew_tween.tween_property(sprite, "skew", -.1, 1)
	#skew_tween.tween_property(sprite, "skew", .1, 1)
	#skew_tween.tween_property(sprite, "skew", -.1, 1)
	#skew_tween.tween_property(sprite, "skew", .1, 1)
	
	var pos_tween = create_tween()
	for i in range(30):
		pos_tween.tween_property(sprite, "position", base_pos + Vector2(randi_range(-200, 200), randi_range(-200, 200)), .2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_left -= delta
	
	if time_left < 0:
		visible = false
		await get_tree().create_timer(2.0).timeout
		queue_free()
