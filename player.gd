class_name Player extends CharacterBody3D

enum HELD_ITEM {MIRROR, NONE, BOULDER_LOOT, HOT_COLD, BLUE_GEM, RED_GEM, GREEN_GEM}

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var held_item: HELD_ITEM = HELD_ITEM.NONE

@onready var camera: Camera3D = $Camera3D
@onready var interact_cast: RayCast3D = $Camera3D/InteractRaycast
@onready var held_item_meshes: Node3D = $Camera3D/HeldItems

func _ready() -> void:
	Globals.player = self
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$Visual.visible = false
	
	for held_item: MeshInstance3D in $Camera3D/HeldItems.get_children():
		held_item.visible = false
		var new_mat: StandardMaterial3D = held_item.get_active_material(0).duplicate()
		new_mat.no_depth_test = true
		new_mat.render_priority = 1
		new_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		held_item.material_override = new_mat

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("ui_right"):
		Globals.PUZZLE_SOLVED.emit(Globals.PUZZLE.LIGHT)
	
	if Input.is_action_just_pressed("ui_down"):
		handle_hold_item(HELD_ITEM.HOT_COLD)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var speed: float = SPEED * 3 if Input.is_action_pressed("run") else SPEED
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
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
			mesh.material_override.albedo_color = Color(255 / distance, 0, 0)
		else:
			mesh.material_override.albedo_color = Color(255, 255, 255)

func handle_hold_item(item: HELD_ITEM) -> void:
	print("holding ", item)
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

func lose_held_item() -> void:
	print("no longer holding item")
	held_item = HELD_ITEM.NONE
	for child in held_item_meshes.get_children():
		child.visible = false

func die() -> void:
	print("dying")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * Globals.mouse_sens)
		camera.rotate_x(-event.relative.y * Globals.mouse_sens)
		camera.rotation.x = clampf(camera.rotation.x, -deg_to_rad(85), deg_to_rad(85))
