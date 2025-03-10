class_name GameUi
extends CanvasLayer

@onready var _age_value: ProgressBar = %AgeValue
@onready var _game_over: Control = %GameOver

# Overrides
########################################


func _ready() -> void:
	EventBus.age_changed.connect(_on_age_changed)
	EventBus.game_over_changed.connect(_on_game_over_changed)


# Methods
########################################

# Signal Connections
####################


func _on_age_changed() -> void:
	_age_value.value = GameState.age


func _on_game_over_changed() -> void:
	_game_over.visible = GameState.is_game_over


func _on_return_to_main_menu_button_up() -> void:
	EventBus.return_to_main_menu.emit()
