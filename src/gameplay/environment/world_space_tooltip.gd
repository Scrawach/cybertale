class_name WorldSpaceTooltip
extends Node3D

@onready var label: Label = %Label

func setup(text: String) -> void:
	label.text = text
