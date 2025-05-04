class_name BossRoom
extends ScenarioRoom

@export var boss: Boss

@onready var door_collision_1: CollisionShape3D = $"Doors/Door 1/StaticBody3D/CollisionShape3D"
@onready var door_collision_2: CollisionShape3D = $"Doors/Door 2/StaticBody3D/CollisionShape3D"


func initialize(hero: Hero) -> void:
	pass

func start() -> void:
	boss.health.died.connect(_on_boss_died)

func _on_boss_died() -> void:
	open_arena()
	door.enable()
	door.used.connect(func(body: Hero, _door: NextRoomDoor): completed.emit(_door))

func _on_trigger_zone_body_entered(body: Hero) -> void:
	close_arena()
	start_boss_fight(body)
	$"Trigger Zone/CollisionShape3D".disabled = true

func close_arena() -> void:
	door_collision_1.disabled = false
	door_collision_2.disabled = false

func open_arena() -> void:
	door_collision_1.disabled = true
	door_collision_2.disabled = true

func start_boss_fight(hero: Hero) -> void:
	boss.hud_set_active(true)
	boss.initialize(hero)
