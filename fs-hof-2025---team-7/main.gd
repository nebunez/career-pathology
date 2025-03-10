class_name Main
extends Node

@export var game_scene: PackedScene

@onready var _menu: Control = %MainMenu

# Overrides
########################################


func _ready() -> void:
	EventBus.game_started.connect(_on_start_game)


# Methods
########################################

# Signal Connections
####################


func _on_start_game() -> void:
	var game = game_scene.instantiate()
	self.add_child(game)
	_menu.visible = false
