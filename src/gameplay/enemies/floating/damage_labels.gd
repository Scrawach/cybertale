class_name DamageLabels
extends Node

@export var health: Health
@export var parent: Node3D
@export var spawn_point: Node3D

@onready var template: PackedScene = preload("res://gameplay/common/floating_numbers.tscn")

func _ready() -> void:
	health.damage_taken.connect(_on_damage_taken)

func _on_damage_taken(value: int) -> void:
	var instance = template.instantiate() as FloatingNumbers
	parent.get_parent().add_child(instance)
	instance.setup(spawn_point.global_position, value)
