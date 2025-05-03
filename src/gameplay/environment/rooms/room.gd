class_name Room
extends Node3D

signal teleport_player_to(body: Hero, target: Room)

@export var hero_marker: Marker3D

@onready var nav_region = $NavigationRegion3D

var doors: Array[NextRoomDoor]

func _ready() -> void:
	for child in get_children():
		if child is NextRoomDoor:
			child.teleported.connect(_on_next_room_door_teleported)
			doors.append(child)

func _on_next_room_door_teleported(body: Hero, next_room: Room) -> void:
	teleport_player_to.emit(body, next_room)

func enable() -> void:
	pass

func disable() -> void:
	nav_region.enabled = false

func open_doors() -> void:
	for door in doors:
		door.enable()
