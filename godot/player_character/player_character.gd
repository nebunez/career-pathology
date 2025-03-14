class_name PlayerCharacter
extends RigidBody2D

# Inpiration from:
# https://github.com/godotengine/godot-demo-projects/blob/3.5-9e68af3/2d/physics_platformer/player/player.gd

@export var HEALTH: int = 100
@export var WALK_ACCEL: float = 500.0
@export var WALK_DEACCEL: float = 500.0
@export var WALK_MAX_VELOCITY: float = 140.0
@export var AIR_ACCEL: float = 100.0
@export var AIR_DEACCEL: float = 100.0
@export var JUMP_FORCE: float = 1500.0
@export var JUMP_PENALTY_FORCE: float = 500.0
@export var STOP_JUMP_FORCE: float = 450.0
@export var MAX_SHOOT_POSE_TIME: float = 0.3
@export var MAX_FLOOR_AIRBORNE_TIME: float = 0.15

var anim: String = ""
var siding_left: bool = false
var jumping: bool = false
var stopping_jump: bool = false
var shooting: bool = false
var has_jump_penalty: bool = false
var first_physics_frame_with_jump_penalty: bool = false

var floor_h_velocity: float = 0.0

var airborne_time: float = 1e20
var shoot_time: float = 1e20

#@onready var sound_jump = $SoundJump
#@onready var sound_shoot = $SoundShoot
#@onready var sprite = $Sprite
#@onready var sprite_smoke = sprite.get_node(@"Smoke")
#@onready var animation_player = $AnimationPlayer
#@onready var bullet_shoot = $BulletShoot

@onready var _jump_penalty_timer: Timer = %JumpPenaltyTimer

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var new_velocity: Vector2 = state.get_linear_velocity()
	var step: float = state.get_step()

	var new_anim: String = anim
	var new_siding_left: bool = siding_left

	# get the input
	var move_left: bool = Input.is_action_pressed("move_left")
	var move_right: bool = Input.is_action_pressed("move_right")
	var jump: bool = Input.is_action_pressed("jump")
	var shoot: bool = Input.is_action_pressed("shoot")

	# Deapply prev floor velocity.
	new_velocity.x -= floor_h_velocity
	floor_h_velocity = 0.0

	# get the current floor normal
	var found_floor: bool = false
	var floor_index: int = -1
	for x in range(state.get_contact_count()):
		var ci: Vector2 = state.get_contact_local_normal(x)

		if ci.dot(Vector2(0, -1)) > 0.6:
			found_floor = true
			floor_index = x

#	if shoot and not shooting:
#		call_deferred("_shot_bullet")
#	else:
#		shoot_time += step

	if found_floor:
		airborne_time = 0.0
	else:
		airborne_time += step

	var on_floor: bool = airborne_time < MAX_FLOOR_AIRBORNE_TIME

	# Process jump.
	if jumping:
		if first_physics_frame_with_jump_penalty and new_velocity.y < 0:
			new_velocity.y -= new_velocity.y
		elif new_velocity.y > 0:
			# Set off the jumping flag if going down.
			jumping = false
		elif not jump:
			stopping_jump = true

		if stopping_jump:
			new_velocity.y += STOP_JUMP_FORCE * step

	if on_floor:
		# Process logic when character is on floor.
		if move_left and not move_right:
			if new_velocity.x > -WALK_MAX_VELOCITY:
				new_velocity.x -= WALK_ACCEL * step
		elif move_right and not move_left:
			if new_velocity.x < WALK_MAX_VELOCITY:
				new_velocity.x += WALK_ACCEL * step
		else:
			var xv = abs(new_velocity.x)
			xv -= WALK_DEACCEL * step
			if xv < 0:
				xv = 0
			new_velocity.x = sign(new_velocity.x) * xv

		# Check jump.
		if not jumping and jump:
			var actual_jump_velocity := (
				JUMP_FORCE - JUMP_PENALTY_FORCE
				if has_jump_penalty
				else JUMP_FORCE
			)
			print(actual_jump_velocity)
			new_velocity.y = -actual_jump_velocity
			jumping = true
			stopping_jump = false
#			sound_jump.play()

		# Check siding
		if new_velocity.x < 0 and move_left:
			new_siding_left = true
		elif new_velocity.x > 0 and move_right:
			new_siding_left = false
		if jumping:
			new_anim = "jumping"
		elif abs(new_velocity.x) < 0.1:
			if shoot_time < MAX_SHOOT_POSE_TIME:
				new_anim = "idle_weapon"
			else:
				new_anim = "idle"
		else:
			if shoot_time < MAX_SHOOT_POSE_TIME:
				new_anim = "run_weapon"
			else:
				new_anim = "run"
	else:
		# Process logic when the character is in the air.
		if move_left and not move_right:
			if new_velocity.x > -WALK_MAX_VELOCITY:
				new_velocity.x -= AIR_ACCEL * step
		elif move_right and not move_left:
			if new_velocity.x < WALK_MAX_VELOCITY:
				new_velocity.x += AIR_ACCEL * step
		else:
			var xv = abs(new_velocity.x)
			xv -= AIR_DEACCEL * step

			if xv < 0:
				xv = 0
			new_velocity.x = sign(new_velocity.x) * xv
		if new_velocity.y < 0:
			if shoot_time < MAX_SHOOT_POSE_TIME:
				new_anim = "jumping_weapon"
			else:
				new_anim = "jumping"
		else:
			if shoot_time < MAX_SHOOT_POSE_TIME:
				new_anim = "falling_weapon"
			else:
				new_anim = "falling"

	# Update siding.
	#if new_siding_left != siding_left:
	#if new_siding_left:
	#sprite.scale.x = -1
	#else:
	#sprite.scale.x = 1
#
	#siding_left = new_siding_left
	# Change animation.
	if new_anim != anim:
		anim = new_anim
#		animation_player.play(anim)

	shooting = shoot

	# Apply floor velocity.
	if found_floor:
		floor_h_velocity = state.get_contact_collider_velocity_at_position(floor_index).x
		new_velocity.x += floor_h_velocity

	# Finally, apply gravity and set back the linear velocity.
	new_velocity += state.get_total_gravity() * step
	state.set_linear_velocity(new_velocity)

	first_physics_frame_with_jump_penalty = false


func apply_jump_penalty() -> void:
	has_jump_penalty = true
	first_physics_frame_with_jump_penalty = true
	_jump_penalty_timer.start()


func collect_pickup(career_path: GameState.CareerPath):
	GameState.increment_skill(career_path)


func _on_jump_penalty_timer_timeout() -> void:
	has_jump_penalty = false
