class_name LowHealth
extends Node

@export var health: Health
@export var hero: Hero
@export var low_position: float = 0.3

func _ready() -> void:
	health.changed.connect(_on_health_changed)

func _on_health_changed(new_health: Health) -> void:
	if new_health.max_value * low_position > new_health.value:
		hero.camera.play_low_health()
	else:
		hero.camera.reset_low_health()
