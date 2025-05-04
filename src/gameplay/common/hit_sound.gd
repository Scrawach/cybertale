class_name HitSound
extends Node

@export var health: Health
@export var sound_path: String

func _ready() -> void:
	health.damage_taken.connect(_on_damage_taken)

func _on_damage_taken(value: int) -> void:
	Audio.play(sound_path, Vector2(0.8, 0.9), true)
