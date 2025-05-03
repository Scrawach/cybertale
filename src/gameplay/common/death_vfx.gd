class_name DeathVFX
extends Node

@export var health: Health
@export var parent: Node3D
@export var spawn_point: Node3D
@export var scene: PackedScene

func _ready() -> void:
	health.died.connect(_on_died)

func _on_died() -> void:
	var instance = scene.instantiate()
	parent.get_parent().add_child(instance)
	instance.global_position = spawn_point.global_position
