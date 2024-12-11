extends Resource

const SAVE_GAME_PATH := "res://savegame.bin"

var current_save : Dictionary = {
	highscore = 0
}

func save_game() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var data: Dictionary = {}
