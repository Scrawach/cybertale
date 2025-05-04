class_name Health
extends Node

signal changed(health: Health)
signal damage_taken(damage: int)
signal died()

@export var value: int
@export var max_value: int

func initialize(new_value: int) -> void:
	value = new_value
	max_value = new_value
	changed.emit(self)

func restore() -> void:
	value = max_value
	changed.emit(self)

func increase_max_value(increase: int) -> void:
	max_value += increase
	heal(increase)
	changed.emit(self)

func take_damage(strength: int) -> void:
	value = max(0, value - strength)
	damage_taken.emit(strength)
	changed.emit(self)
	
	if value == 0:
		died.emit()

func heal(strength: int) -> void:
	value = min(value + strength, max_value)
	changed.emit(self)
