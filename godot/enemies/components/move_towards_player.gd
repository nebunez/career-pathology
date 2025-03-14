class_name MoveTowardsPlayer
extends Node2D

const PLAYER_CHARACTER_GROUP_NAME := &"Player Character"

@export var speed: float = 400

var _player_character: PlayerCharacter
var _velocity: Vector2

@onready var target: Node2D = self.owner


func _ready() -> void:
	if get_tree().get_node_count_in_group(PLAYER_CHARACTER_GROUP_NAME) != 1:
		push_error("Found more or less than 1 node in the player character group.")
		return

	_player_character = get_tree().get_first_node_in_group(PLAYER_CHARACTER_GROUP_NAME)
	var direction: Vector2 = (
		(_player_character.global_position - target.global_position).normalized()
	)
	_velocity = direction * speed


func _process(delta: float) -> void:
	target.position += _velocity * delta
