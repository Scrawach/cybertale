class_name FloatingSphere
extends Node3D

func _on_hurt_box_area_entered(area: Area3D) -> void:
	queue_free()
