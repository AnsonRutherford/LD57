extends Node

@onready var exit_button: Button = $UI/Button

func _ready():
	exit_button.pressed.connect(_on_exit_button_pressed)
	
func _on_exit_button_pressed():
	Globals.load_main_menu()
