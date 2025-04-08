extends Control

@onready var button = $VBoxContainer/Button

func _ready() -> void:
	button.pressed.connect(_button)
	
func _button() -> void:
	Globals.load_main_menu()
