extends Node3D

var is_found: bool = false

func interact() -> void:
	if !is_found:
		print("secret note gained")
		is_found = true
		Globals.SECRET_NOTE_ACQUIRED.emit()
		#Globals.start_dialogue(self, "you found a secret note!")
		visible = false
