class_name ScenarioRoom
extends Node3D

signal completed(door: NextRoomDoor)

@export var door: NextRoomDoor
@export var player_spawn: Marker3D

func start() -> void:
	door.used.connect(func(body: Hero, _door: NextRoomDoor): 
		completed.emit(_door))

func stop() -> void:
	pass
