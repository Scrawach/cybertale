class_name FightingRoom
extends Room

@export var want_to_spawn: int
@export var max_enemy_for_room: int
@export var spawn_targets: Array[PackedScene]
@export var spawn_vfx: PackedScene

@onready var enemies: Node3D = $"Enemies"
@onready var timer: Timer = $Timer
@onready var region: NavigationRegion3D = $NavigationRegion3D

var spawned: int = 0

func _ready() -> void:
	super._ready()
	timer.timeout.connect(_on_timeout)

func enable() -> void:
	await get_tree().create_timer(0.5).timeout
	for i in want_to_spawn:
		spawn_random_enemy_at_random_point()
		spawned += 1
		await get_tree().create_timer(0.25).timeout
		

func spawn_random_enemy_at_random_point() -> void:
	var random_point: Vector3 = NavigationServer3D.map_get_random_point(region.get_navigation_map(), 1, true)
	spawn_spawn_vfx(random_point + Vector3.UP)
	await get_tree().create_timer(0.1).timeout
	
	var random_enemy_scene: PackedScene = spawn_targets.pick_random() as PackedScene
	var enemy_instance = random_enemy_scene.instantiate()
	
	enemies.add_child(enemy_instance)
	enemy_instance.global_position = random_point

func spawn_spawn_vfx(target: Vector3) -> void:
	var instance = spawn_vfx.instantiate()
	get_parent().add_child(instance)
	instance.global_position = target

func _on_timeout() -> void:
	if enemies.get_child_count() < 1 and want_to_spawn == spawned:
		timer.stop()
		open_doors()
