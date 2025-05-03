class_name DungeonGenerator
extends Node3D

@export var current_room: Room

func _ready() -> void:
	initialize()

func initialize() -> void:
	for child in get_children():
		if child is Room:
			child.teleport_player_to.connect(_on_player_teleported)

func _on_player_teleported(body: Hero, room: Room) -> void:
	if current_room != null:
		current_room.disable()
		current_room.queue_free()
	
	body.global_position = room.hero_marker.global_position
	room.enable()
	current_room = room
