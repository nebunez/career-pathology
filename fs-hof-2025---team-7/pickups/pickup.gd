class_name Pickup
extends Area2D

@export var art_icon: Texture2D
@export var business_icon: Texture2D
@export var gaming_icon: Texture2D
@export var music_icon: Texture2D
@export var writing_icon: Texture2D
@export var art_color: Color
@export var business_color: Color
@export var gaming_color: Color
@export var music_color: Color
@export var writing_color: Color

@export var career_path: GameState.CareerPath

@onready var _background: Sprite2D = %Background
@onready var _icon: Sprite2D = %Icon

# Overrides
########################################


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	_set_pickup_color_and_icon()


# Methods
########################################


func _set_pickup_color_and_icon() -> void:
	match career_path:
		GameState.CareerPath.ART:
			_background.modulate = art_color
			_icon.texture = art_icon
		GameState.CareerPath.BUSINESS:
			_background.modulate = business_color
			_icon.texture = business_icon
		GameState.CareerPath.GAMING:
			_background.modulate = gaming_color
			_icon.texture = gaming_icon
		GameState.CareerPath.MUSIC:
			_background.modulate = music_color
			_icon.texture = music_icon
		GameState.CareerPath.WRITING:
			_background.modulate = writing_color
			_icon.texture = writing_icon


# Signal Connections
####################


func _on_body_entered(body: Node2D) -> void:
	if body is PlayerCharacter:
		body.collect_pickup(career_path)

	queue_free()
