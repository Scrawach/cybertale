class_name HitFlash
extends Node

@export var animation: AnimationPlayer
@export var animation_name: String

@export var health: Health

func _ready() -> void:
	health.damage_taken.connect(_on_damage_taken)

func _on_damage_taken(value: int) -> void:
	animation.play(animation_name)
