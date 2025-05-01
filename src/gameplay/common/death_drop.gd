class_name DeathDrop
extends Node

@export var health: Health
@export var parent: Node3D

@export var drop_template: PackedScene
@export var count_of_drop: int = 10

@export var vertical_strength: float = 15
@export var horizontal_strength: float = 4

func _ready() -> void:
	health.died.connect(_on_died)

func _on_died() -> void:
	var bodies: Array[RigidBody3D]
	for index in count_of_drop:
		var drop_instance: RigidBody3D = drop_template.instantiate()
		parent.get_parent().add_child(drop_instance)
		drop_instance.global_position = parent.global_position
		bodies.append(drop_instance)
	
	drop(bodies)

func drop(bodies: Array[RigidBody3D]) -> void:
	var angle_step: float = 360 / bodies.size()
	var angle: float = 0
	for body in bodies:
		var direction: Vector3 = Vector3.LEFT.rotated(Vector3.UP, deg_to_rad(angle)).normalized()
		body.apply_impulse(Vector3.UP * vertical_strength + direction * horizontal_strength)
		angle += angle_step
