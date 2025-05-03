class_name RoomIcon
extends TextureRect

@onready var color_rect: Panel = $Panel

@export var reach_color: Color
@export var unreach_color: Color

func mark_as_reach() -> void:
	color_rect.modulate = reach_color

func mark_as_unreach() -> void:
	color_rect.modulate = unreach_color
