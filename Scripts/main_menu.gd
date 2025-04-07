extends Control

@onready var start_button: Button = $%StartButton

func _ready():
	start_button.pressed.connect(_on_start_button_pressed)
	
func _on_start_button_pressed():
	Globals.load_gameplay()
