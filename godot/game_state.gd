class_name GameState
extends Node

enum CareerPath { ART, BUSINESS, GAMING, MUSIC, WRITING }

const BASE_SKILL_VALUE: float = 5.0
const BASE_SELECTED_SKILL_VALUE: float = 15.0
const BASE_SKILL_INCREMENT_VALUE: float = 5.0
## Amount to increment age per second
const BASE_AGE_INCREMENT_VALUE: float = 0.6
const BASE_AGE_MULTIPLIER: float = 1.0
const AGE_ACCELERATION_AMOUNT: float = 0.2

# Game State
####################

static var is_game_over: bool = false
static var is_victory: bool = false

# Player Values
####################

static var chosen_path: CareerPath
static var age: float = 0.0
static var age_multiplier: float = BASE_AGE_MULTIPLIER
static var skills := {
	CareerPath.ART: BASE_SKILL_VALUE,
	CareerPath.BUSINESS: BASE_SKILL_VALUE,
	CareerPath.GAMING: BASE_SKILL_VALUE,
	CareerPath.MUSIC: BASE_SKILL_VALUE,
	CareerPath.WRITING: BASE_SKILL_VALUE
}
static var skill_multiplier: float = 1.0

# Functions
########################################


static func reset() -> void:
	age = 0.0
	age_multiplier = 1.0
	is_game_over = false
	is_victory = false
	_reset_skills()


## Increment age each frame.
##
## This function is meant to be called each frame, with [member delta] being the time since last
## frame.
static func increment_age(delta: float) -> void:
	var amount := (BASE_AGE_INCREMENT_VALUE * delta) * age_multiplier
	age = age + amount


static func accelerate_age() -> void:
	age_multiplier += AGE_ACCELERATION_AMOUNT


static func increment_skill(career_path: CareerPath) -> void:
	var amount := BASE_SKILL_INCREMENT_VALUE * skill_multiplier
	skills[career_path] = skills[career_path] + amount
	EventBus.skill_changed.emit(career_path)


static func set_skill(career_path: CareerPath, value: float) -> void:
	skills[career_path] = value
	EventBus.skill_changed.emit(career_path)


static func set_game_over(value: bool) -> void:
	is_game_over = value
	EventBus.game_over_changed.emit()


static func set_is_victory(value: bool) -> void:
	is_victory = value
	EventBus.is_victory_changed.emit()


static func _reset_skills() -> void:
	for career_path: CareerPath in skills.keys():
		var value = BASE_SELECTED_SKILL_VALUE if career_path == chosen_path else BASE_SKILL_VALUE
		set_skill(career_path, value)
