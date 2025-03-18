class_name GameUi
extends CanvasLayer

@onready var _age_value: ProgressBar = %AgeValue
@onready var _game_over: Control = %GameOver
@onready var _art_value: Label = %ArtValue
@onready var _business_value: Label = %BusinessValue
@onready var _gaming_value: Label = %GamingValue
@onready var _music_value: Label = %MusicValue
@onready var _writing_value: Label = %WritingValue
@onready var _game_over_result: Label = %GameOverResult

# Overrides
########################################


func _ready() -> void:
	EventBus.skill_changed.connect(_on_skill_changed)
	EventBus.game_over_changed.connect(_on_game_over_changed)


func _process(_delta: float) -> void:
	_age_value.value = GameState.age

# Methods
########################################


func _update_skill_text(career_path: GameState.CareerPath) -> void:
	var value: float = GameState.skills[career_path]
	var label: Label
	match career_path:
		GameState.CareerPath.ART:
			label = _art_value

		GameState.CareerPath.BUSINESS:
			label = _business_value

		GameState.CareerPath.GAMING:
			label = _gaming_value

		GameState.CareerPath.MUSIC:
			label = _music_value

		GameState.CareerPath.WRITING:
			label = _writing_value

		_:
			push_error("Unknown skill name")

	label.text = "%d" % value


# Signal Connections
####################


func _on_skill_changed(career_path: GameState.CareerPath) -> void:
	_update_skill_text(career_path)


func _on_game_over_changed() -> void:
	_game_over_result.text = (
		"You've completed your dream! ✌️" if GameState.is_victory else "You died of old age! 🪦"
	)
	_game_over.visible = GameState.is_game_over


func _on_return_to_main_menu_button_up() -> void:
	EventBus.return_to_main_menu.emit()
