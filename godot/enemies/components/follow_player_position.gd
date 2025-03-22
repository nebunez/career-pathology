class_name FollowPlayerPosition
extends Node2D

var _offset_from_player: Vector2
var _player_character: PlayerCharacter

@onready var _target: Node2D = self.owner

# Overrides
########################################


func _ready() -> void:
	if get_tree().get_node_count_in_group(Globals.PLAYER_CHARACTER_GROUP_NAME) != 1:
		push_error("Found more or less than 1 node in the player character group.")
		return

	_player_character = get_tree().get_first_node_in_group(Globals.PLAYER_CHARACTER_GROUP_NAME)
	_offset_from_player = _target.global_position - _player_character.global_position


func _process(_delta: float) -> void:
	if _player_character == null:
		return

	_target.global_position = _player_character.global_position + _offset_from_player
