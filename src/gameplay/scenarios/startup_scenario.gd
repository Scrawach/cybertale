class_name StartupScenario
extends Node

@export var startup_room: ScenarioRoom
@export var bridge_room: ScenarioRoom
@export var training_room: ScenarioRoom
@export var training_room2: ScenarioRoom

func _ready() -> void:
	execute()

func execute() -> void:
	var hero = await wait_complete(startup_room)
	startup_room.queue_free()
	hero.global_position = bridge_room.player_spawn.global_position
	
	hero = await wait_complete(bridge_room)
	bridge_room.queue_free()
	hero.global_position = training_room.player_spawn.global_position
	
	training_room.start()
	hero = await wait_complete(training_room)
	training_room.queue_free()
	
	training_room2.start()
	hero.global_position = training_room2.player_spawn.global_position
	print("COMPLETED!")

func wait_complete(room: ScenarioRoom) -> Hero:
	var result = await room.door.teleported
	return result[0] as Hero
