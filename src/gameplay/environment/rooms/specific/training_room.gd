class_name TrainingRoom
extends ScenarioRoom

@export var want_to_spawn: int
@export var max_enemies_count: int
@export var region: NavigationRegion3D
@export var spawn_targets: Array[PackedScene]
@export var spawn_vfx: PackedScene

@onready var timer: Timer = $Timer
@onready var enemies: Node3D = $Enemies

var alive_enemies: int
var spawned: int

var settings: RoomSpawnSettings
var random_query: Array

func setup(settings: RoomSpawnSettings) -> void:
	self.settings = settings
	self.max_enemies_count = settings.max_alive_enemies
	self.want_to_spawn = 0
	for item in settings.enemies:
		self.want_to_spawn += item.count
		for i in item.count:
			random_query.push_back(item.scene)
	random_query.shuffle()

func start() -> void:
	region.enabled = true
	timer.timeout.connect(_on_timeout)
	await get_tree().create_timer(0.1).timeout
	
	if settings != null:
		setting_driven_spawn()
	else:
		default_spawn()

func _on_spawn() -> void:
	pass

func setting_driven_spawn() -> void:
	while random_query.size() > 0:
		var scene: PackedScene = random_query.pop_front()
		spawn_random_enemy_at_random_point(scene)
		await get_tree().create_timer(settings.pause_between_spawns).timeout
		
		spawned += 1
		alive_enemies += 1
		_on_spawn()
		
		while alive_enemies > max_enemies_count:
			await timer.timeout

func default_spawn() -> void:
	for i in want_to_spawn:
		spawn_random_enemy_at_random_point(spawn_targets.pick_random())
		await get_tree().create_timer(0.3).timeout
		spawned += 1
		alive_enemies += 1
		
		while alive_enemies > max_enemies_count:
			await timer.timeout

func stop() -> void:
	region.enabled = false

func spawn_random_enemy_at_random_point(scene: PackedScene) -> void:
	var random_point: Vector3 = NavigationServer3D.map_get_random_point(region.get_navigation_map(), 1, true)
	spawn_spawn_vfx(random_point + Vector3.UP)
	await get_tree().create_timer(0.2).timeout
	
	var enemy_instance = scene.instantiate()
	
	enemies.add_child(enemy_instance)
	enemy_instance.global_position = random_point

func spawn_spawn_vfx(target: Vector3) -> void:
	var instance = spawn_vfx.instantiate()
	get_parent().add_child(instance)
	instance.global_position = target

func _on_timeout() -> void:
	alive_enemies = get_enemies_count()
	if alive_enemies < 1 and want_to_spawn <= spawned:
		timer.stop()
		door.enable()

func get_enemies_count() -> int:
	var counter: int
	for child in enemies.get_children():
		if child is RigidBody3D or child is GPUParticles3D:
			continue
		
		counter += 1
	return counter
