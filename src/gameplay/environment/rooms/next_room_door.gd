class_name NextRoomDoor
extends Node3D

signal used(hero: Hero, door: NextRoomDoor)

@export var next_room: String
@export var is_disable: bool

@onready var collision: CollisionShape3D = $"Teleport Area/CollisionShape3D"
@onready var view: Node3D = $View
@onready var animation: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	if is_disable:
		disable()

func disable() -> void:
	collision.disabled = true
	view.visible = false

func enable() -> void:
	Audio.play("res://gameplay/environment/sounds/door-open.wav", Vector2(0.8, 0.9), true)
	animation.play("open")
	MainCamera.point.shake(0.2)
	await get_tree().create_timer(0.1).timeout
	view.visible = true
	await get_tree().create_timer(1.0).timeout
	collision.disabled = false

func _on_teleport_area_body_entered(body: Hero) -> void:
	used.emit(body, self)
