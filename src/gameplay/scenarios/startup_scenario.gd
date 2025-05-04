class_name StartupScenario
extends Node

@export var hero: Hero
@export var startup_room: ScenarioRoom
@export var bridge_room: ScenarioRoom
@export var training_room: ScenarioRoom
@export var dash_room: ScenarioRoom

@export var gameplay_world: GameplayWorld

@onready var tutorial_label: Label = $"../CanvasLayer/Tutorial Label"

func _ready() -> void:
	execute()

func execute() -> void:
	hero.show_health_bar(false)
	hero.set_hud_active(false)
	var hero = await wait_complete(startup_room)
	startup_room.queue_free()
	hero.global_position = bridge_room.player_spawn.global_position
	#tutorial_label.text = tr("TUTORIAL_ATTACK_KEY")
	hero.set_hud_active(true)
	hero = await wait_complete(bridge_room)
	bridge_room.queue_free()
	hero.global_position = training_room.player_spawn.global_position
	
	training_room.start()
	#tutorial_label.text = ""
	hero.show_health_bar(true)
	hero = await wait_complete(training_room)
	training_room.queue_free()
	hero.global_position = dash_room.player_spawn.global_position
	
	dash_room.start()
	#tutorial_label.text = tr("TUTORIAL_DASH_KEY")
	hero.health.damage_taken.connect(_on_damage_taken)
	await dash_room.completed
	hero.health.damage_taken.disconnect(_on_damage_taken)
	dash_room.queue_free()
	tutorial_label.text = ""
	gameplay_world.start(hero)

func _on_damage_taken(value: int) -> void:
	hero.global_position = dash_room.player_spawn.global_position
	hero.health.restore()

func wait_complete(room: ScenarioRoom) -> Hero:
	var result = await room.door.used
	return result[0] as Hero
