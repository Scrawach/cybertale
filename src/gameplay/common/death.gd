class_name Death
extends Node

@export var health: Health
@export var body: Node3D

func _ready() -> void:
	health.died.connect(_on_died)

func _on_died() -> void:
	# play die animation
	# disable AI and etc
	body.queue_free()
