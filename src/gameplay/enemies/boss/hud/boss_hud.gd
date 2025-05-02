class_name BossHud
extends Node

@export var health: Health

@onready var health_bar: ProgressBar = $ProgressBar

func _ready() -> void:
	health.changed.connect(_on_health_changed)
	_on_health_changed(health)

func _on_health_changed(changed_health: Health) -> void:
	health_bar.value = changed_health.value
	health_bar.max_value = changed_health.max_value
