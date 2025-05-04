class_name GameplayWorld
extends Node3D

const OFFSET_BETWEEN_ROOMS: float = 50

@export var number_of_rooms: int = 5

@export var fighting_room_template: PackedScene
@export var boss_room_template: PackedScene
@export var shoop_room_template: PackedScene
@export var revive_room_template: PackedScene
@export var last_window: Control

@export var settings: GameplaySpawnSettings

@onready var progress: SmartProgressBar = $"Game Progress/MarginContainer/ProgressBar"
@onready var defeat_all_label: Control = $"Game Progress/Defeat All"
@onready var defeat_all_timer: Timer = $"Game Progress/Defeat All/Timer"

var hero: Hero
var current_room: int

var previous_room_position: Vector3
var previous_room: ScenarioRoom

var force_shop_spawn: bool
var is_shop_spawned: bool
var is_died: bool

var is_active: bool = false

func start(hero: Hero) -> void:
	is_active = true
	
	self.hero = hero
	var room = await create_fight_room()
	previous_room = room
	hero.global_position = room.player_spawn.global_position
	
	progress.show()
	await get_tree().create_timer(0.1).timeout
	progress.setup_path(number_of_rooms)
	current_room += 1
	progress.complete_room(current_room)
	
	room.start()
	defeat_all_label.show()
	defeat_all_timer.start()
	await defeat_all_timer.timeout
	var tween = create_tween()
	tween.tween_property(defeat_all_label, "modulate:a", 0, 1.0)
	tween.tween_callback(func(): defeat_all_label.hide())
	
	var door: NextRoomDoor = await room.completed
	
	if not is_died:
		gameloop()

func gameloop() -> void:
	while current_room != (number_of_rooms + 1):
		previous_room.stop()
		await get_tree().create_timer(0.1).timeout
		var room: ScenarioRoom = create_next_room()
		hero.global_position = room.player_spawn.global_position
		invoke_before_room_effects()
		room.start()
		previous_room.queue_free()
		previous_room = room
		var door: NextRoomDoor = await room.completed
		if door == null: # hero is die
			is_died = true
			return
		invoke_after_room_effects()
		
	if not is_died:
		last_window.visible = true

func invoke_before_room_effects() -> void:
	for effect in hero.effects:
		effect.before_room()

func invoke_after_room_effects() -> void:
	for effect in hero.effects:
		effect.after_room()

func wait_completed_or_dead() -> void:
	
	pass

func create_next_room() -> ScenarioRoom:
	var room: ScenarioRoom
	
	if force_shop_spawn or not is_shop_spawned and current_room % 2 == 0:
		room = create_shop_room()
		is_shop_spawned = true
		force_shop_spawn = false
	else:
		is_shop_spawned = false
		
		if current_room == number_of_rooms:
			room = create_boss_room()
		else:
			room = create_fight_room()
			
		current_room += 1
		progress.complete_room(current_room)
	
	return room

func create_fight_room() -> FightRoom:
	var fight_room: FightRoom = create_room(fighting_room_template)
	var index = min(current_room, settings.settings.size() - 1)
	fight_room.setup(settings.settings[index])
	
	return fight_room

func create_boss_room() -> BossRoom:
	var boss_room: BossRoom = create_room(boss_room_template)
	boss_room.initialize(hero)
	return boss_room

func create_shop_room() -> ShopRoom:
	var shop_room: ShopRoom = create_room(shoop_room_template)
	shop_room.initialize(hero)
	return shop_room

func create_room(template: PackedScene) -> ScenarioRoom:
	var next_room_position: Vector3 = previous_room_position + Vector3(OFFSET_BETWEEN_ROOMS, 0, 0)
	var fight_room: ScenarioRoom = template.instantiate() as ScenarioRoom
	add_child(fight_room)
	fight_room.global_position = next_room_position
	previous_room_position = next_room_position
	return fight_room

func revive_hero() -> void:
	is_died = true
	previous_room.completed.emit(null)
	current_room -= 1
	current_room = max(0, current_room)
	
	hero.set_input_active(false)
	
	var revive_room = create_room(revive_room_template)
	hero.global_position = revive_room.player_spawn.global_position
	hero.health.restore()
	
	previous_room.queue_free()
	previous_room = revive_room
	
	hero.set_input_active(true)
	is_died = false
	revive_room.start()
	var door = await revive_room.completed
	force_shop_spawn = true
	gameloop()
