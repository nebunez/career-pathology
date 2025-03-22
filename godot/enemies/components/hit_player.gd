class_name HitPlayer
extends Node2D

enum OnHitEffect { JUMP_PENALTY, STUN, ACCELERATE_AGE }

@export var on_hit_effect: OnHitEffect
@export var destroy_on_hit: bool

@onready var _target: Area2D = self.owner


func _ready() -> void:
	_target.body_entered.connect(_target_on_body_entered)


func _target_on_body_entered(body: Node2D) -> void:
	if body is PlayerCharacter:
		body.on_projectile_hit(self.on_hit_effect)

	if self.destroy_on_hit:
		_target.queue_free()
