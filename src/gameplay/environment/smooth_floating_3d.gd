class_name SmoothFloating3D
extends Node

@export var target: Node3D

@export var amplitude: float = 0.15
@export var speed: float = 0.3

var initial_position: Vector3

func _ready() -> void:
	initial_position = target.position

func _physics_process(delta: float) -> void:
	var phase: float = Time.get_ticks_msec() * delta * speed + initial_position.x
	target.position = initial_position + amplitude * Vector3.UP * sin(phase)
