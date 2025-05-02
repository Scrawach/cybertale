class_name EnemyProjectile
extends Node3D

@export var movement_speed: float = 10.0

var movement_direction: Vector3

func launch(direction: Vector3) -> void:
	movement_direction = direction.normalized()

func _physics_process(delta: float) -> void:
	var step = movement_direction * movement_speed * delta
	position += step

func _on_life_time_timer_timeout() -> void:
	queue_free()

func _on_area_3d_area_entered(area: Area3D) -> void:
	queue_free()
