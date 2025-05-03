class_name CameraPoint
extends Node3D

@export var target: Node3D

@onready var camera: Camera3D = $"Camera Length/Camera3D"
@onready var shaker: CameraShaker = $"Camera Shaker"

@onready var vignette: ColorRect = %Vignette

var base_size: float
var tween: Tween

func _ready() -> void:
	MainCamera.point = self
	base_size = camera.size

func _physics_process(_delta: float) -> void:
	if target == null:
		return
	
	global_position = target.global_position

func shake(strength: float = 0.1):
	shaker.shake(strength)

func add_size(value: float) -> void:
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.tween_property(camera, "size", base_size + value, 0.3)

func play_take_damage() -> void:
	pass

func play_low_health() -> void:
	#print("low health!")
	pass

func reset_low_health() -> void:
	#print("no low health")
	pass

func reset_vignette() -> void:
	pass

func reset_size() -> void:
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.tween_property(camera, "size", base_size, 0.3)


func get_mouse_position_in_world_3d() -> Vector3:
	var plane = Plane(Vector3(0, 1, 0), 0)
	var ray_length = 1000
	var mouse_position = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_position)
	var to = from + camera.project_ray_normal(mouse_position) * ray_length
	var cursor_position_on_plane = plane.intersects_ray(from, to)
	return cursor_position_on_plane
