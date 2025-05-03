class_name Spikes
extends Node3D

@onready var animation: AnimationPlayer = $spikes/AnimationPlayer

func _on_hurt_box_area_entered(area: Area3D) -> void:
	animation.play("attack")
