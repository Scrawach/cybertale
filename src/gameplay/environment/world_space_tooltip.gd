class_name WorldSpaceTooltip
extends Node3D

@export var initial_text: String
@onready var label: Label = %Label

func _ready() -> void:
	label.text = initial_text

func setup(text: String) -> void:
	label.text = text
