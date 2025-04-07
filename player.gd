class_name Player extends CharacterBody3D

enum HELD_ITEM {MIRROR, NONE, BOULDER_LOOT, HOT_COLD, BLUE_GEM, RED_GEM, GREEN_GEM, DART}

const SPEED = 7.5
const JUMP_VELOCITY = 4.5

var held_item: HELD_ITEM = HELD_ITEM.NONE

@onready var camera: Camera3D = $Camera3D
@onready var interact_cast: RayCast3D = $Camera3D/InteractRaycast
@onready var held_item_meshes: Node3D = $Camera3D/HeldItems
@onready var pickup_sound: AudioStreamPlayer = $PickupAudio
@onready var red_hot_sound: AudioStreamPlayer = $RedHotAudio
@onready var ghost_rotation: Node3D = $GhostSpawnRotation
@onready var ghost_location: Marker3D = $GhostSpawnRotation/GhostSpawnLocation
@onready var ghost_ray: RayCast3D = $GhostSpawnRotation/GhostRaycast
@onready var room_detector: Area3D = $RoomDetector

var dart_scene: PackedScene = preload("res://Scenes/throwing_dart.tscn")
var dart_cd: float = 1.0

var held_items_base_pos: Vector3
@onready var held_items_anim_player: AnimationPlayer = $Camera3D/HeldItemAnimations

var cycles_done: int = 0

func _ready() -> void:
	Globals.player = self
	$Visual.visible = false
	held_items_base_pos = held_item_meshes.position
	Globals.END_DIALOGUE.connect(_on_end_dialogue)
	
	for held_item: MeshInstance3D in $Camera3D/HeldItems.get_children():
		held_item.visible = false
		var new_mat: StandardMaterial3D = held_item.get_active_material(0).duplicate()
		new_mat.no_depth_test = true
		new_mat.render_priority = 1
		
		if held_item.name != "HotCold":
			new_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		
		held_item.material_override = new_mat
		
func _process(_delta) -> void:
	if Globals.dialogue:
		match_dialogue_camera()

func _physics_process(delta: float) -> void:
	if Globals.paused or Globals.dialogue:
		return
	
	dart_cd -= delta
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("ui_right"):
		Globals.PUZZLE_SOLVED.emit(Globals.PUZZLE.MOON_LIGHT)
	
	if Input.is_action_just_pressed("ui_down"):
		GhostService.spawn_ghost()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var speed: float = SPEED * 2 if Input.is_action_pressed("run") else SPEED
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
	# item bobbing
	if velocity.x != 0 && velocity.z != 0:
		var bob_speed = 3.0 if Input.is_action_pressed("run") else 1.5
		held_items_anim_player.play("moving2", -1, bob_speed)
	else:
		held_items_anim_player.play("still", .15)
	
	# interact/pickup
	if Input.is_action_just_pressed("interact") && interact_cast.is_colliding():
		var collide_with: Node = interact_cast.get_collider()
		# currently this requires the parent to have the interactable script
		var parent: Node = collide_with.get_parent()
		if parent.has_method("interact"):
			parent.interact()
	
	if Input.is_action_just_pressed("pickup") && interact_cast.is_colliding():
		var collide_with: Node = interact_cast.get_collider()
		# currently this requires the parent to have the interactable script
		var parent: Node = collide_with.get_parent()
		if parent.has_method("pickup"):
			parent.pickup(self)
	
	if held_item == HELD_ITEM.HOT_COLD:
		var mesh = $%HotCold
		if $HotColdArea.has_overlapping_areas():
			var nearby_areas = $HotColdArea.get_overlapping_areas()
			var distance = self.global_position.distance_to(nearby_areas[0].global_position) * 50
			print("distance: ", distance)
			print(255 / distance)
			mesh.material_override.albedo_color = Color(255 / distance, 0, 0, .4)
			
			red_hot_sound.volume_db = -12
			red_hot_sound.pitch_scale = 255/distance
			red_hot_sound.play()
		else:
			red_hot_sound.stop()
			mesh.material_override.albedo_color = Color(1, 1, 1, .4)
	
	if held_item == HELD_ITEM.DART:
		if Input.is_action_just_pressed("interact") && dart_cd < 0:
			print("throwing dart")
			var dart: Node3D = dart_scene.instantiate()
			Globals.add_child(dart)
			dart.global_position = $%Dart.global_position
			dart.global_rotation = camera.global_rotation
			$DartThrowAudio.play()
			dart_cd = 1.0
			$%Dart.visible = false
			await get_tree().create_timer(1).timeout
			if held_item == HELD_ITEM.DART:
				$%Dart.visible = true

func handle_hold_item(item: HELD_ITEM) -> void:
	print("holding ", item)
	var was_holding_item = held_item != HELD_ITEM.NONE
	lose_held_item()
	held_item = item
	
	match item:
		HELD_ITEM.MIRROR:
			$%Mirror.visible = true
		HELD_ITEM.HOT_COLD:
			$%HotCold.visible = true
		HELD_ITEM.GREEN_GEM:
			$%GreenGem.visible = true
		HELD_ITEM.BLUE_GEM:
			$%BlueGem.visible = true
		HELD_ITEM.RED_GEM:
			$%RedGem.visible = true
		HELD_ITEM.DART:
			$%Dart.visible = true
	
	if was_holding_item:
		pickup_sound.pitch_scale = .7
		pickup_sound.play()
	elif item != HELD_ITEM.NONE:
		pickup_sound.pitch_scale = 1.0
		pickup_sound.play()

func lose_held_item() -> void:
	print("no longer holding item")
	held_item = HELD_ITEM.NONE
	for child in held_item_meshes.get_children():
		child.visible = false

func die() -> void:
	print("dying")
	
func _on_end_dialogue() -> void:
	camera.make_current()
	match_dialogue_camera()

func match_dialogue_camera() -> void:
	var dc_forward = -DialogueCamera.instance.basis.z
	var dc_pos = DialogueCamera.instance.global_position
	var dc_look = dc_pos + dc_forward
	var dc_flat_look = dc_look
	dc_flat_look.y = global_position.y
	look_at(dc_flat_look)
	camera.look_at(dc_look)
	camera.rotation.y = 0
	camera.rotation.z = 0

func _input(event: InputEvent) -> void:
	if Globals.paused or Globals.dialogue:
		return
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * Globals.mouse_sens)
		camera.rotate_x(-event.relative.y * Globals.mouse_sens)
		camera.rotation.x = clampf(camera.rotation.x, -deg_to_rad(85), deg_to_rad(85))

func is_in_treasure_room() -> bool:
	return room_detector.has_overlapping_areas()

func cycle_complete() -> void:
	cycles_done += 1
	print("playing completed cycle: ", cycles_done)
