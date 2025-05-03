extends Control

@export var artifacts: Node

func _ready() -> void:
	await get_tree().create_timer(0.5).timeout
	artifacts.queue_free()
	
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 0.5)
	tween.tween_callback(func(): hide())
