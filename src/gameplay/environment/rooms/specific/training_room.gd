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

func start() -> void:
	region.enabled = true
	timer.timeout.connect(_on_timeout)
	await get_tree().create_timer(0.1).timeout
	for i in want_to_spawn:
		spawn_random_enemy_at_random_point()
		await get_tree().create_timer(0.4).timeout
		spawned += 1
		alive_enemies += 1
		
		while alive_enemies > max_enemies_count:
			await timer.timeout

func stop() -> void:
	region.enabled = false

func spawn_random_enemy_at_random_point() -> void:
	var random_point: Vector3 = NavigationServer3D.map_get_random_point(region.get_navigation_map(), 1, true)
	spawn_spawn_vfx(random_point + Vector3.UP)
	await get_tree().create_timer(0.2).timeout
	
	var random_enemy_scene: PackedScene = spawn_targets.pick_random() as PackedScene
	var enemy_instance = random_enemy_scene.instantiate()
	
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
		if child is RigidBody3D:
			continue
		
		counter += 1
	return counter
