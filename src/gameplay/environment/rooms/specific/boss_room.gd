class_name BossRoom
extends ScenarioRoom

@export var boss: Boss

func initialize(hero: Hero) -> void:
	boss.initialize(hero)

func start() -> void:
	boss.health.died.connect(_on_boss_died)

func _on_boss_died() -> void:
	door.enable()
	door.used.connect(func(body: Hero, _door: NextRoomDoor): completed.emit(_door))
