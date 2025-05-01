class_name CameraPoint
extends Node3D

@export var target: Node3D

@onready var camera: Camera3D = $"Camera Length/Camera3D"
@onready var shaker: CameraShaker = $"Camera Shaker"

func _physics_process(_delta: float) -> void:
	if target == null:
		return
	
	global_position = target.global_position

func shake(strength: float = 0.1):
	shaker.shake(strength)

func get_mouse_position_in_world_3d() -> Vector3:
	var plane = Plane(Vector3(0, 1, 0), 0)
	var ray_length = 1000
	var mouse_position = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_position)
	var to = from + camera.project_ray_normal(mouse_position) * ray_length
	var cursor_position_on_plane = plane.intersects_ray(from, to)
	return cursor_position_on_plane
