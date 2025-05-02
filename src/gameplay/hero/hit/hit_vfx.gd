class_name HitVFX
extends Node3D

@export var play_on_ready: bool

@onready var animation: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	if play_on_ready:
		animation.play("play")

func _on_timer_timeout() -> void:
	queue_free()
