class_name ProjectileSpawner
extends Node2D
## A versatile projectile spawner.
##
## When [member spawner_type] is [enum SpawnerType.TRIGGER], projectiles are spawned by an external
## source.[br]
##
## When [member spawner_type] is [enum SpawnerType.TIMER], projectiles are spawned on a timer. Note
## [member _spawn_timer.one_shot] is forced to [code]true[/code] and the timer is manually started
## in order to facilitate random spawn times.[br]
##
## If [member min_spawn_time] and [member max_spawn_time] are different values, then spawn times
## will be random between those two values. If they are the same value, then spawn times will be
## consistent for that value.

enum SpawnerType { TRIGGER, TIMER }

@export var parent_group_name: StringName
@export var projectile_scene: PackedScene
@export var flash_point_sprite_frames: SpriteFrames
@export var delay_projectile_after_flash: bool = false
@export var spawner_type: SpawnerType
## Minimum spawn time (in seconds)
@export_range(0.0, 300.0) var min_spawn_time: float
@export_range(0.0, 300.0) var spawn_time_range: float

var _target: Node2D
var _timer_is_random: bool = false
var _use_flash_point: bool = false

@onready var _flash_point_animated_sprite_2d: AnimatedSprite2D = %FlashPointAnimatedSprite2D
@onready var _spawn_point: Node2D = %SpawnPoint
@onready var _spawn_timer: Timer = %SpawnTimer

# Overrides
########################################


func _ready() -> void:
	_init_target()
	_init_timer()
	_init_flash_point()


# Methods
########################################


func start_spawn_projectile() -> void:
	if _use_flash_point:
		_flash_point_animated_sprite_2d.visible = true
		_flash_point_animated_sprite_2d.play()

	if not self.delay_projectile_after_flash:
		_spawn_projectile()


func _init_target() -> void:
	if (
		parent_group_name == null
		or parent_group_name.is_empty()
		or self.get_tree().get_node_count_in_group(parent_group_name) == 0
	):
		_target = self.owner
	else:
		_target = self.get_tree().get_first_node_in_group(parent_group_name)


func _init_timer() -> void:
	if self.spawner_type != SpawnerType.TIMER:
		return

	_spawn_timer.one_shot = true
	_spawn_timer.autostart = false
	_spawn_timer.timeout.connect(_on_spawn_timer_timeout)

	if self.spawn_time_range > 0.0:
		_timer_is_random = true

	_start_timer()


func _init_flash_point() -> void:
	if flash_point_sprite_frames == null:
		return

	_use_flash_point = true
	_flash_point_animated_sprite_2d.visible = false
	_flash_point_animated_sprite_2d.sprite_frames = flash_point_sprite_frames

	_flash_point_animated_sprite_2d.animation_finished.connect(
		_on_flash_point_animated_sprite_2d_animation_finished
	)


func _start_timer() -> void:
	var wait_time: float
	if _timer_is_random:
		var max_range := self.min_spawn_time + self.spawn_time_range
		wait_time = randf_range(self.min_spawn_time, max_range)
	else:
		wait_time = self.min_spawn_time

	_spawn_timer.wait_time = wait_time
	_spawn_timer.start()


func _spawn_projectile() -> void:
	var projectile = self.projectile_scene.instantiate() as Node2D
	_target.add_child(projectile)
	projectile.global_position = _spawn_point.global_position


# Signal Connections
####################


func _on_spawn_timer_timeout() -> void:
	start_spawn_projectile()
	_start_timer()


func _on_flash_point_animated_sprite_2d_animation_finished() -> void:
	_flash_point_animated_sprite_2d.visible = false
	if self.delay_projectile_after_flash:
		_spawn_projectile()
