class_name HitPlayer
extends Node2D

enum OnHitEffect { JUMP_PENALTY, STUN, ACCELERATE_AGE }

@export var on_hit_effect: OnHitEffect

@onready var _target: Area2D = self.owner


func target_on_body_entered(body: Node2D) -> void:
	if body is PlayerCharacter:
		body.on_projectile_hit(self.on_hit_effect)

	_target.queue_free()
