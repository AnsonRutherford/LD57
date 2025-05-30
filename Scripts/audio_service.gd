extends Node

var puzzle_complete_player: AudioStreamPlayer
var music: AudioStreamPlayer

var puzzles_solved: Array[Globals.PUZZLE] = []

func _ready() -> void:
	puzzle_complete_player = AudioStreamPlayer.new()
	puzzle_complete_player.stream = preload("res://audio/puzzle_jingle.ogg")
	add_child(puzzle_complete_player)
	Globals.PUZZLE_SOLVED.connect(play_puzzle_jingle)
	music = AudioStreamPlayer.new()
	music.stream = preload("res://audio/song_cropped.ogg")
	add_child(music)
	music.volume_db = -8.0
	music.play()

func play_puzzle_jingle(puzzle: Globals.PUZZLE):
	if puzzles_solved.has(puzzle):
		return
	print("playing puzzle solved jingle")
	puzzles_solved.append(puzzle)
	puzzle_complete_player.play(2.9)
