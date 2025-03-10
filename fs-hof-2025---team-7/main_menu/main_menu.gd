class_name MainMenu
extends Control

@onready var _credits: Control = %Credits


func _on_show_credits_button_up() -> void:
	_credits.visible = true


func _on_credits_back_button_up() -> void:
	_credits.visible = false


func _on_start_game_button_up() -> void:
	EventBus.game_started.emit()


func _on_quit_button_up() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
