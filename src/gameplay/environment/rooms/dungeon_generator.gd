class_name DungeonGenerator
extends Node3D

func _ready() -> void:
	initialize()

func initialize() -> void:
	for child in get_children():
		if child is Room:
			child.teleport_player_to.connect(_on_player_teleported)

func _on_player_teleported(body: Hero, room: Room) -> void:
	body.global_position = room.hero_marker.global_position
	room.enable()
