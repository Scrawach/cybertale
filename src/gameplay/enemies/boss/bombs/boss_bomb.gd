class_name BossBomb
extends RigidBody3D

@onready var boom_timer: Timer = $"Boom Timer"
@onready var boom_zone: Node3D = $Area3D/MeshInstance3D
@onready var damage_collider: CollisionShape3D = $Area3D/CollisionShape3D
@onready var boom_vfx: Node3D = $Area3D/MeshInstance3D2

func _ready() -> void:
	boom_timer.timeout.connect(_on_boom_timeout)
	await get_tree().create_timer(1.5).timeout
	start_bomb()

func start_bomb() -> void:
	boom_timer.start()
	boom_zone.visible = true

func _on_boom_timeout() -> void:
	boom_vfx.visible = true
	damage_collider.set_deferred("disabled", false)
	await get_tree().create_timer(0.1).timeout
	boom_vfx.visible = false
	damage_collider.set_deferred("disabled", true)
	queue_free()
