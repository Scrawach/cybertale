class_name StartupScenario
extends Node

@export var hero: Hero
@export var startup_room: ScenarioRoom
@export var bridge_room: ScenarioRoom
@export var training_room: ScenarioRoom
@export var gameplay_world: GameplayWorld

func _ready() -> void:
	execute()

func execute() -> void:
	hero.show_health_bar(false)
	var hero = await wait_complete(startup_room)
	startup_room.queue_free()
	hero.global_position = bridge_room.player_spawn.global_position
	
	hero = await wait_complete(bridge_room)
	bridge_room.queue_free()
	hero.global_position = training_room.player_spawn.global_position
	
	training_room.start()
	hero.show_health_bar(true)
	hero = await wait_complete(training_room)
	training_room.queue_free()
	gameplay_world.start(hero)

func wait_complete(room: ScenarioRoom) -> Hero:
	var result = await room.door.teleported
	return result[0] as Hero
