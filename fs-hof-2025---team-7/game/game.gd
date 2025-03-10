class_name Game
extends Node2D

@onready var _age_timer: Timer = %AgeTimer

# Overrides
########################################


func _ready() -> void:
	_start_game()


func _process(_delta: float) -> void:
	_check_game_over()


# Methods
########################################


func _start_game() -> void:
	_age_timer.stop()
	_age_timer.start()
	GameState.reset()


func _check_game_over() -> void:
	if GameState.age == 100:
		GameState.set_game_over(true)


# Signal Connections
####################


func _on_age_timer_timeout() -> void:
	GameState.increment_age()
