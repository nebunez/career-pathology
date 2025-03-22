class_name MoveTowardsPlayer
extends Node2D

## Minimum speed (in seconds)
@export_range(100.0, 1_000.0) var min_speed: float
@export_range(0.0, 1_000.0) var speed_range: float
@export var angle_variance_degrees: float = 15.0

var _player_character: PlayerCharacter
var _velocity: Vector2

@onready var _target: Node2D = self.owner

# Overrides
########################################


func _ready() -> void:
	if get_tree().get_node_count_in_group(Globals.PLAYER_CHARACTER_GROUP_NAME) != 1:
		push_error("Found more or less than 1 node in the player character group.")
		return

	_player_character = get_tree().get_first_node_in_group(Globals.PLAYER_CHARACTER_GROUP_NAME)
	var direction: Vector2 = (
		(_player_character.global_position - _target.global_position).normalized()
	)

	var speed: float
	if self.speed_range > 0.0:
		randomize()
		speed = randf_range(self.min_speed, self.min_speed + self.speed_range)
	else:
		speed = self.min_speed

	var angle_variance_rad: float = deg_to_rad(
		randf_range(-angle_variance_degrees, angle_variance_degrees)
	)
	direction = direction.rotated(angle_variance_rad)

	_velocity = direction * speed


func _process(delta: float) -> void:
	_target.global_position += _velocity * delta
