class_name BillSpawner
extends Node2D

@export var bill_scene: PackedScene
@export var player_path: NodePath  # Path to the player node

# Spawn interval range in seconds
@export var min_spawn_time: float = 1.0
@export var max_spawn_time: float = 3.0

# Speed range for bills
@export var min_speed: float = 100.0
@export var max_speed: float = 200.0

@export var angle_variance_degrees: float = 15.0

# Timer for spawning
var spawn_timer: float = 0.0
var time_until_next_spawn: float = 0.0
var player: Node2D

# Offset from player
var offset_from_player: Vector2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Initialize random spawn time
	randomize()
	time_until_next_spawn = randf_range(min_spawn_time, max_spawn_time)

	# Get player reference
	if player_path:
		player = get_node(player_path)
		offset_from_player = global_position - player.global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player == null:
		return

	# Update position to follow player
	global_position = player.global_position + offset_from_player

	# Update spawn timer
	spawn_timer += delta

	# Check if it's time to spawn
	if spawn_timer >= time_until_next_spawn:
		spawn_bill()
		spawn_timer = 0
		time_until_next_spawn = randf_range(min_spawn_time, max_spawn_time)


func spawn_bill() -> void:
	# Create instance of bill
	var bill_instance: Node = bill_scene.instantiate()
	self.get_parent().add_child(bill_instance)

	# Set the bill's initial position to the spawner's position
	bill_instance.global_position = global_position

	# Calculate direction toward player
	var direction: Vector2 = (player.global_position - global_position).normalized()

	# Add random angle variance
	var angle_variance_rad: float = deg_to_rad(
		randf_range(-angle_variance_degrees, angle_variance_degrees)
	)
	direction = direction.rotated(angle_variance_rad)

	# Randomize speed
	var speed: float = randf_range(min_speed, max_speed)

	# Set velocity
	bill_instance.velocity = direction * speed
