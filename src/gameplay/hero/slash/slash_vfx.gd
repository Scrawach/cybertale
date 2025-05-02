class_name SlashVFX
extends Node3D

@onready var animation: AnimationPlayer = $AnimationPlayer

func play() -> void:
	animation.play("slash")
