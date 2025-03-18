class_name Cloud
extends RigidBody2D

@export var has_stress: bool

var _stress_scene := preload("res://enemies/stress/stress.tscn")

@onready var _stress_spawn_point: Node2D = %StressSpawnPoint

# Overrides
########################################

func _ready() -> void:
	if has_stress:
		var stress := _stress_scene.instantiate() as Node2D
		self.add_child(stress)
		stress.position = _stress_spawn_point.position
