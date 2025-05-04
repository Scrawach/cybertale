class_name BossBombs
extends BossStage

@export var boss: Boss
@export var bombs_count: int = 5
@export var bomb_template: PackedScene
@export var fire_point: Marker3D
@export var bomb_height_spawn: float = 10

func start() -> void:
	var target: Hero = boss.hero
	#preparing before bombs?
	for i in bombs_count:
		var bomb: BossBomb = bomb_template.instantiate()
		boss.owner.add_child(bomb)
		bomb.global_position = target.global_position + Vector3.UP * bomb_height_spawn
		await get_tree().create_timer(1.0).timeout
	boss.switch_to(BossWaiting)

func process(delta: float) -> void:
	pass

func stop() -> void:
	pass
