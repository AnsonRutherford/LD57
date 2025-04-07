class_name InventoryNoteVisual extends Panel

var text: String = "uh oh"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gui_input.connect(_handle_hover)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _handle_hover(event: InputEvent) -> void:
	Globals.NOTE_HOVERED.emit(self)

func set_image():
	pass
