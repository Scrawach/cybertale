class_name SpawnGuards
extends Node

@export var boss: Boss
@export var health: Health
@export var required_minimum_health_1: int
@export var required_minimum_health_2: int
@export var agent: NavigationAgent3D
@export var spawn_vfx: PackedScene

@export var settings: RoomSpawnSettings

var random_query: Array

var is_happened_1: bool = false
var is_happened_2: bool = false

func _ready() -> void:
	health.changed.connect(_on_health_changed)
	
func _on_health_changed(new_health: Health) -> void:
	if not is_happened_1 and new_health.value < required_minimum_health_1:
		is_happened_1 = true
		setup(settings)
		spawn_guards()
		
	if not is_happened_2 and new_health.value < required_minimum_health_2:
		is_happened_2 = true
		setup(settings)
		spawn_guards()

func spawn_guards() -> void:
	setting_driven_spawn()

func setup(settings: RoomSpawnSettings) -> void:
	self.settings = settings
	random_query.clear()
	for item in settings.enemies:
		for i in item.count:
			random_query.push_back(item.scene)
	random_query.shuffle()

func setting_driven_spawn() -> void:
	while random_query.size() > 0:
		var scene: PackedScene = random_query.pop_front()
		spawn_random_enemy_at_random_point(scene)
		await get_tree().create_timer(settings.pause_between_spawns).timeout


func spawn_random_enemy_at_random_point(scene: PackedScene) -> void:
	var random_point: Vector3 = NavigationServer3D.map_get_random_point(agent.get_navigation_map(), 1, true)
	spawn_spawn_vfx(random_point + Vector3.UP)
	await get_tree().create_timer(0.2).timeout
	
	var enemy_instance = scene.instantiate()
	
	boss.get_parent().add_child(enemy_instance)
	enemy_instance.global_position = random_point

func spawn_spawn_vfx(target: Vector3) -> void:
	var instance = spawn_vfx.instantiate()
	get_parent().add_child(instance)
	instance.global_position = target
