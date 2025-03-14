class_name Bill
extends Area2D

# Movement velocity
var velocity: Vector2 = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var delete_timer = Timer.new()
	delete_timer.wait_time = 5.0  # can make this a variable so spawner can set it
	delete_timer.one_shot = true
	delete_timer.timeout.connect(_on_delete_timer_timeout)
	add_child(delete_timer)
	delete_timer.start()

	# Set up collision detection
	body_entered.connect(_on_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Move the bill according to its velocity
	position += velocity * delta


func _on_delete_timer_timeout() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	# Check if collided with player
	if body is PlayerCharacter:
		body.on_projectile_hit(HitPlayer.OnHitEffect.JUMP_PENALTY)

	# Queue free in any case (when hitting any body)
	queue_free()
