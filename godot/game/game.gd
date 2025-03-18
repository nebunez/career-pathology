class_name Game
extends Node2D

# Overrides
########################################


func _ready() -> void:
	_start_game()


func _process(_delta: float) -> void:
	GameState.increment_age(_delta)
	_check_game_over()


# Methods
########################################


func _start_game() -> void:
	GameState.reset()


func _check_game_over() -> void:
	if GameState.skills[GameState.chosen_path] >= 100.0:
		GameState.set_is_victory(true)
		GameState.set_game_over(true)
	elif GameState.age >= 100:
		GameState.set_game_over(true)
