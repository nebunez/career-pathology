class_name Mover
extends Node2D

enum MoveAxis {
	## [member _target] moves x axis.
	HORIZONTAL,
	## [member _target] moves along the y axis.
	VERTICAL
}

## How the [member _target] moves.
enum MoveBehaviour {
	## When [member _target] reaches its range, in pixels, it will stop moving.
	MOVE_AND_STOP,
	## When [member _target] reaches its move range limit, it will begin moving in the other
	## direction.
	LOOP,
	## The [member _target]will never stop moving in its initial direction.
	INFINITE
}

## The [member _target]'s initial position in relation to its range.
enum InitialPosition { START, CENTER, END }

## The direction in which the [member _target] initially moves.
enum Direction {
	## The [member _target] begins moving right, or down.
	POSITIVE,
	## The [member _target] begins moving left, or up.
	NEGATIVE
}

@export var move_axis: MoveAxis
@export var move_behaviour: MoveBehaviour
@export var initial_position: InitialPosition
@export var initial_direction: Direction
@export_range(10.0, 1280.0, 1.0) var move_range: float = 10.0
@export_range(10.0, 1000.0, 1.0) var move_speed: float = 10.0

var _start_range_position: Vector2
var _end_range_position: Vector2
var _current_direction: Direction
var _stop_moving: bool = false

@onready var _target: Node2D = self.get_parent()

# Overrides
########################################


func _ready() -> void:
	_current_direction = initial_direction
	_calculate_range_positions()


func _process(delta: float) -> void:
	_update_direction()
	_move_target(delta)


# Methods
########################################


func _calculate_range_positions() -> void:
	match initial_position:
		InitialPosition.START:
			_start_range_position = _target.position
			if move_axis == MoveAxis.HORIZONTAL:
				_end_range_position = Vector2(_target.position.x + move_range, _target.position.y)
			elif move_axis == MoveAxis.VERTICAL:
				_end_range_position = Vector2(_target.position.x, _target.position.y + move_range)

		InitialPosition.END:
			_end_range_position = _target.position
			if move_axis == MoveAxis.HORIZONTAL:
				_start_range_position = Vector2(_target.position.x - move_range, _target.position.y)
			elif move_axis == MoveAxis.VERTICAL:
				_start_range_position = Vector2(_target.position.x, _target.position.y - move_range)

		InitialPosition.CENTER:
			if move_axis == MoveAxis.HORIZONTAL:
				_start_range_position = Vector2(
					_target.position.x - (move_range / 2.0), _target.position.y
				)
				_end_range_position = Vector2(
					_target.position.x + (move_range / 2.0), _target.position.y
				)
			elif move_axis == MoveAxis.VERTICAL:
				_start_range_position = Vector2(
					_target.position.x, _target.position.y - (move_range / 2.0)
				)
				_end_range_position = Vector2(
					_target.position.x, _target.position.y + (move_range / 2.0)
				)

		_:
			push_error("Unknown InitialPosition: %d" % initial_position)


func _update_direction() -> void:
	if move_behaviour == MoveBehaviour.INFINITE:
		return

	if _current_direction == Direction.POSITIVE and _target.position >= _end_range_position:
		if move_behaviour == MoveBehaviour.MOVE_AND_STOP:
			_stop_moving = true
			return

		_current_direction = Direction.NEGATIVE
	elif _current_direction == Direction.NEGATIVE and _target.position <= _start_range_position:
		if move_behaviour == MoveBehaviour.MOVE_AND_STOP:
			_stop_moving = true
			return

		_current_direction = Direction.POSITIVE


func _move_target(frame_delta: float) -> void:
	if _stop_moving:
		return

	var direction_scalar := 1 if _current_direction == Direction.POSITIVE else -1
	var move_delta := move_speed * direction_scalar * frame_delta

	if move_axis == MoveAxis.HORIZONTAL:
		_target.move_local_x(move_delta)
	elif move_axis == MoveAxis.VERTICAL:
		_target.move_local_y(move_delta)
