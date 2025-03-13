class_name TitleMenu
extends Control

const STORY_RES_BASE_PATH := "res://story"

var _copies := {
	art_path = "", gaming_path = "", music_path = "", business_path = "", writing_path = ""
}

@onready var _start_game: Button = %StartGame
@onready var _exposition: Label = %Exposition

# Overrides
########################################


func _init() -> void:
	_copies.art_path = _get_text_file_body(STORY_RES_BASE_PATH.path_join("Art Path Copy.txt"))
	_copies.gaming_path = _get_text_file_body(STORY_RES_BASE_PATH.path_join("Gaming Path Copy.txt"))
	_copies.music_path = _get_text_file_body(STORY_RES_BASE_PATH.path_join("Music Path Copy.txt"))
	_copies.business_path = _get_text_file_body(
		STORY_RES_BASE_PATH.path_join("Business Path Copy.txt")
	)
	_copies.writing_path = _get_text_file_body(
		STORY_RES_BASE_PATH.path_join("Writing Path Copy.txt")
	)


# Methods
########################################


func _get_text_file_body(filepath: String) -> String:
	var file := FileAccess.open(filepath, FileAccess.READ)
	var body = file.get_as_text()
	file.close()

	return body


# Signal Connections
####################


func _on_art_path_button_up() -> void:
	GameState.chosen_path = GameState.CareerPath.ART
	_exposition.text = _copies.art_path
	_start_game.disabled = false


func _on_gaming_path_button_up() -> void:
	GameState.chosen_path = GameState.CareerPath.GAMING
	_exposition.text = _copies.gaming_path
	_start_game.disabled = false


func _on_music_path_button_up() -> void:
	GameState.chosen_path = GameState.CareerPath.MUSIC
	_exposition.text = _copies.music_path
	_start_game.disabled = false


func _on_business_path_button_up() -> void:
	GameState.chosen_path = GameState.CareerPath.BUSINESS
	_exposition.text = _copies.business_path
	_start_game.disabled = false


func _on_writing_path_button_up() -> void:
	GameState.chosen_path = GameState.CareerPath.WRITING
	_exposition.text = _copies.writing_path
	_start_game.disabled = false
