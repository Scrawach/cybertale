class_name ScenarioRoom
extends Node3D

signal completed(door: NextRoomDoor)

@export var door: NextRoomDoor
@export var player_spawn: Marker3D

func start() -> void:
	pass 

func stop() -> void:
	pass
