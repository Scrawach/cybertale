class_name NextRoomDoor
extends Node3D

@export var next_room: Room
@export var is_disable: bool

@onready var collision: CollisionShape3D = $"Teleport Area/CollisionShape3D"
@onready var view: Node3D = $View
@onready var animation: AnimationPlayer = $AnimationPlayer

signal teleported(body: Hero, next_room: Room)

func _ready() -> void:
	if is_disable:
		disable()

func _on_teleport_area_body_entered(body: Hero) -> void:
	teleported.emit(body, next_room)

func disable() -> void:
	collision.disabled = true
	view.visible = false

func enable() -> void:
	animation.play("open")
	await get_tree().create_timer(0.1).timeout
	view.visible = true
	await get_tree().create_timer(1.0).timeout
	collision.disabled = false
