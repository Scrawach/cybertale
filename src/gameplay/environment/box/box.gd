class_name Box
extends Node3D

@onready var broken_box: PackedScene = preload("res://gameplay/environment/box/broken_box.tscn")

func spawn_broken_box() -> void:
	Audio.play("res://gameplay/environment/sounds/box-destroy.wav", Vector2(0.9, 1.1), true)
	var instance = broken_box.instantiate()
	get_parent().add_child(instance)
	instance.position = position
