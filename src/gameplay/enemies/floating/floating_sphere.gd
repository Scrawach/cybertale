class_name FloatingSphere
extends Node3D

@onready var model_player: AnimationPlayer = $View/floating_sphere/AnimationPlayer
@onready var idle_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	model_player.seek(randf_range(0.0, 1.0))
	idle_player.seek(randf_range(0.0, 1.0))

func _on_hurt_box_area_entered(area: Area3D) -> void:
	queue_free()
