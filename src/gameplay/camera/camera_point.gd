class_name CameraPoint
extends Node3D

@export var target: Node3D

@onready var camera: Camera3D = $"Camera Length/Camera3D"
@onready var shaker: CameraShaker = $"Camera Shaker"

func _physics_process(delta: float) -> void:
	if target == null:
		return
	
	global_position = target.global_position

func shake(strength: float = 0.1):
	shaker.shake(strength)
