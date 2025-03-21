class_name Main
extends Node

@export var game_scene: PackedScene

var _game: Game

@onready var _menu: Control = %MainMenu

# Overrides
########################################


func _ready() -> void:
	EventBus.game_started.connect(_on_start_game)
	EventBus.return_to_main_menu.connect(_on_return_to_main_menu)
	EventBus.quit_requested.connect(_on_quit_requested)


# Methods
########################################

# Signal Connections
####################


func _on_start_game() -> void:
	_game = game_scene.instantiate()
	self.add_child(_game)
	_menu.visible = false


func _on_return_to_main_menu() -> void:
	_game.queue_free()
	_menu.visible = true


func _on_quit_requested() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()
