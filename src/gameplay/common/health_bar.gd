class_name HealthBar
extends Node3D

@export var health: Health

@onready var bar: ProgressBar = $SubViewport/ProgressBar
@onready var label: Label = $"SubViewport/ProgressBar/Health Value"

func _ready() -> void:
	health.changed.connect(_on_health_changed)
	_on_health_changed(health)

func _on_health_changed(updated_health: Health) -> void:
	bar.max_value = updated_health.max_value
	bar.value = updated_health.value
	label.text = "%s / %s" % [updated_health.value, updated_health.max_value]
