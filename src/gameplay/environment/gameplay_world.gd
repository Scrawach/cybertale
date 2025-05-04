class_name GameplayWorld
extends Node3D

const OFFSET_BETWEEN_ROOMS: float = 50

@export var number_of_rooms: int = 5

@export var fighting_room_template: PackedScene
@export var boss_room_template: PackedScene

@export var last_window: Control

@onready var progress: SmartProgressBar = $"Game Progress/MarginContainer/ProgressBar"

var hero: Hero
var current_room: int

var previous_room_position: Vector3
var previous_room: ScenarioRoom

func start(hero: Hero) -> void:
	self.hero = hero
	var room = await create_fight_room()
	previous_room = room
	hero.global_position = room.player_spawn.global_position
	
	progress.show()
	await get_tree().create_timer(0.1).timeout # yep
	progress.setup_path(number_of_rooms)
	
	room.start()
	var door: NextRoomDoor = await room.completed
	current_room += 1
	progress.complete_room(current_room)
	gameloop()
	

func gameloop() -> void:
	while current_room != (number_of_rooms + 1):
		previous_room.stop()
		await get_tree().create_timer(0.1).timeout
		var room: ScenarioRoom
		
		print(current_room)
		if current_room == number_of_rooms:
			room = create_boss_room()
		else:
			room = create_fight_room()
		
		hero.global_position = room.player_spawn.global_position
		room.start()
		previous_room.queue_free()
		var door: NextRoomDoor = await room.completed
		previous_room = room
		current_room += 1
		progress.complete_room(current_room)
	last_window.visible = true

func create_fight_room() -> FightRoom:
	return create_room(fighting_room_template)

func create_boss_room() -> BossRoom:
	var boss_room: BossRoom = create_room(boss_room_template)
	boss_room.initialize(hero)
	return boss_room

func create_room(template: PackedScene) -> ScenarioRoom:
	var next_room_position: Vector3 = previous_room_position + Vector3(OFFSET_BETWEEN_ROOMS, 0, 0)
	var fight_room: ScenarioRoom = template.instantiate() as ScenarioRoom
	add_child(fight_room)
	fight_room.global_position = next_room_position
	previous_room_position = next_room_position
	return fight_room
