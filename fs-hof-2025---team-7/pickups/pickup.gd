class_name Pickup
extends Area2D

@export var career_path: GameState.CareerPath


func _ready() -> void:
	# Set up collision detection
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	# Check if collided with player
	if body is PlayerCharacter:
		body.collect_pickup(career_path)

	# Queue free in any case (when hitting any body)
	queue_free()
