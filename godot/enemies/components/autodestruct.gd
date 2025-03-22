class_name Autodestruct
extends Node2D

@export var time_to_live: float = 5.0

@onready var _target: Node2D = self.owner


func _ready() -> void:
	var delete_timer = Timer.new()
	delete_timer.wait_time = self.time_to_live
	delete_timer.one_shot = true
	delete_timer.timeout.connect(_on_delete_timer_timeout)
	self.add_child(delete_timer)
	delete_timer.start()


func _on_delete_timer_timeout() -> void:
	_target.queue_free()
