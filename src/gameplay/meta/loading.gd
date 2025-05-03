extends Control

@export var artifacts: Node

func _ready() -> void:
	await get_tree().create_timer(1.0).timeout
	artifacts.queue_free()
	hide()
