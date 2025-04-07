extends Control

@onready var pause_menu = $"Pause Menu"
@onready var note_container = $"Pause Menu/NoteContainer"
@onready var focused_note_container = $"Pause Menu/FocusedNoteContainer"
@onready var exit_button = $"Pause Menu/Exit Button"

@onready var dialogue = $Dialogue
@onready var text = $Dialogue/Text

const char_time := 0.03
const extra_char_time = {
	".": 0.4,
	"!": 0.4,
	"?": 0.4,
	",": 0.2,
	";": 0.2,
}
var typing_tween: Tween = null
var animating = false

var hovered_note: InventoryNoteVisual

func _ready() -> void:
	pause_menu.visible = false
	dialogue.visible = false
	Globals.GAME_PAUSED.connect(_on_game_paused)
	Globals.GAME_UNPAUSED.connect(_on_game_unpaused)
	Globals.START_DIALOGUE.connect(_on_dialogue)
	Globals.CONTINUE_DIALOGUE.connect(_on_dialogue)
	Globals.END_DIALOGUE.connect(_on_end_dialogue)
	exit_button.pressed.connect(_on_exit_button_pressed)
	Globals.SECRET_NOTE_ACQUIRED.connect(_on_secret_note_found)
	Globals.NOTE_HOVERED.connect(_on_note_hovered)
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Pause"):
		Globals.toggle_pause()
	if Globals.dialogue and Input.is_action_just_released("interact"):
		if typing_tween and animating:
			skip_animation()
		else:
			Globals.dialogue_next()
			
func skip_animation() -> void:
	typing_tween.custom_step(999)

func _on_game_paused() -> void:
	pause_menu.visible = true
	
func _on_game_unpaused() -> void:
	pause_menu.visible = false
	
func _on_dialogue(speaker: Node3D, message: String) -> void:
	dialogue.visible = true
	text.clear()
	text.append_text(message)
	typing_tween = create_tween()
	
	var real_text = text.get_parsed_text()
	var type_time = len(real_text) * char_time
	for char in real_text:
		if char in extra_char_time.keys():
			type_time += extra_char_time[char]
	text.visible_ratio = 0
	animating = true
	typing_tween.tween_property(text, "visible_ratio", 1, type_time)
	typing_tween.tween_property(self, "animating", false, 0)
	
func _on_end_dialogue() -> void:
	dialogue.visible = false	
	
func _on_exit_button_pressed():
	Globals.load_main_menu()

func _on_secret_note_found(note_found: SecretNote):
	var note: InventoryNoteVisual = preload("res://Scenes/InventoryNoteVisual.tscn").instantiate()
	
	if len(note_found.lines) > 0:
		note.text = ""
		for line in note_found.lines:
			note.text +=  "\n" + line
	
	note_container.add_child(note)

func _on_note_hovered(note: InventoryNoteVisual):
	if note == hovered_note:
		return
	for child in focused_note_container.get_children():
		child.queue_free()
	var focused_note = preload("res://Scenes/InventoryNoteVisual.tscn").instantiate()
	focused_note.text = note.text
	focused_note.custom_minimum_size = Vector2(300, 300)
	focused_note.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	focused_note.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	focused_note_container.add_child(focused_note)
	
	var label = Label.new()
	label.text = note.text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	focused_note_container.add_child(label)
