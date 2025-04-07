class_name InventoryNoteVisual extends TextureRect

var text: String = "uh oh"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gui_input.connect(_handle_hover)
	texture_filter = TEXTURE_FILTER_NEAREST


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _handle_hover(event: InputEvent) -> void:
	Globals.NOTE_HOVERED.emit(self)

func set_image(texture: Texture2D):
	self.texture = texture
