class_name GameState
extends Node

enum CareerPath { ART, BUSINESS, GAMING, MUSIC, WRITING }

# Game State
####################

static var is_game_over: bool = false

# Player Values
####################

static var chosen_path: CareerPath
static var age: float = 0.0

# Trackers
####################

static var age_increment_value: float = 5

# Functions
########################################


static func reset() -> void:
	age = 0.0


static func increment_age() -> void:
	age = age + age_increment_value
	EventBus.age_changed.emit()


static func set_game_over(value: bool) -> void:
	is_game_over = value
	EventBus.game_over_changed.emit()
