class_name GameplayWorld
extends Node3D

const OFFSET_BETWEEN_ROOMS: float = 50

@export var number_of_rooms: int = 5

@export var fighting_room_template: PackedScene

@onready var progress: SmartProgressBar = $"Game Progress/MarginContainer/ProgressBar"

var hero: Hero
var current_room: int
var previous_room_position: Vector3

func start(hero: Hero) -> void:
	self.hero = hero
	var room = await create_fight_room()
	hero.global_position = room.player_spawn.global_position
	
	progress.show()
	await get_tree().create_timer(0.1).timeout # yep
	progress.setup_path(number_of_rooms)
	
	room.start()

func gameloop() -> void:
	current_room = 0
	pass

func create_fight_room() -> FightRoom:
	var next_room_position: Vector3 = previous_room_position + Vector3(OFFSET_BETWEEN_ROOMS, 0, 0)
	var fight_room: FightRoom = fighting_room_template.instantiate() as FightRoom
	add_child(fight_room)
	fight_room.global_position = next_room_position
	return fight_room
