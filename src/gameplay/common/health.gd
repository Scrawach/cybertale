class_name Health
extends Node

signal changed(health: Health)
signal died()

@export var value: int
@export var max_value: int

func take_damage(strength: int) -> void:
	value = max(0, value - strength)
	print(value)
	changed.emit(self)
	
	if value == 0:
		died.emit()

func heal(strength: int) -> void:
	value = min(value + strength, max_value)
	changed.emit(self)
