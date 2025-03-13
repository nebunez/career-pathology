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

@export var projectile_scene: PackedScene
@export var projectile_parent_path: NodePath
@export var flash_point_sprite_frames: SpriteFrames
@export var delay_projectile_after_flash: bool = false
@export var spawner_type: SpawnerType
## Minimum spawn time (in seconds)
@export_range(0.0, 10_000.0) var min_spawn_time: float
## Maximum spawn time (in seconds)
@export_range(0.0, 100_000.0) var max_spawn_time: float

var _timer_is_random: bool = false
var _use_flash_point: bool = false

@onready var _projectile_parent: Node2D = (
	self.get_node(self.projectile_parent_path) if self.projectile_parent_path != null else null
)
@onready var _flash_point_animated_sprite_2d: AnimatedSprite2D = %FlashPointAnimatedSprite2D
@onready var _spawn_point: Node2D = %SpawnPoint
@onready var _spawn_timer: Timer = %SpawnTimer

# Overrides
########################################


func _ready() -> void:
	_ensure_correct_spawn_times()
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


func _ensure_correct_spawn_times() -> void:
	# I tried to puth these two checks in their own respective setters, but it did not work.
	if self.min_spawn_time > self.max_spawn_time:
		self.min_spawn_time = self.max_spawn_time

	if self.max_spawn_time < self.min_spawn_time:
		max_spawn_time = self.min_spawn_time


func _init_timer() -> void:
	if self.spawner_type != SpawnerType.TIMER:
		return

	_spawn_timer.one_shot = true
	_spawn_timer.autostart = false
	_spawn_timer.timeout.connect(_on_spawn_timer_timeout)

	if self.min_spawn_time != self.max_spawn_time:
		randomize()
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
		wait_time = randf_range(self.min_spawn_time, self.max_spawn_time)
	else:
		wait_time = self.min_spawn_time

	_spawn_timer.wait_time = wait_time
	_spawn_timer.start()


func _spawn_projectile() -> void:
	var projectile = self.projectile_scene.instantiate() as Node2D
	projectile.position = _spawn_point.position

	_projectile_parent.add_child(projectile)


# Signal Connections
####################


func _on_spawn_timer_timeout() -> void:
	start_spawn_projectile()
	_start_timer()


func _on_flash_point_animated_sprite_2d_animation_finished() -> void:
	_flash_point_animated_sprite_2d.visible = false
	if self.delay_projectile_after_flash:
		_spawn_projectile()
