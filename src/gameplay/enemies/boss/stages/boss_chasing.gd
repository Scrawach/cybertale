class_name BossChasing
extends BossStage

@export var boss: Boss
@export var movement_speed: float = 5.0
@export var attack_range: float = 5.0
@export var nav_agent: NavigationAgent3D
@export var collision: CollisionShape3D
@export var attack_area: Node3D
@export var animation: AnimationPlayer
@export var attack_vfx: PackedScene

var is_movement: bool = true

func start() -> void:
	pass

func process(delta: float) -> void:
	if is_movement:
		nav_agent.target_position = boss.hero.global_position
		_process_movement(delta)
	
	var target_is_nearest: bool = boss.global_position.distance_to(boss.hero.global_position) < attack_range
	
	if target_is_nearest and is_movement:
		start_attack()

func stop() -> void:
	pass

func start_attack() -> void:
	is_movement = false
	attack_area.visible = true
	animation.play("attack")
	await get_tree().create_timer(0.5).timeout
	var instance = attack_vfx.instantiate()
	boss.get_parent().add_child(instance)
	instance.global_position = attack_area.global_position
	await get_tree().create_timer(0.1).timeout
	MainCamera.point.shake(0.5)
	MainCamera.point.make_screen_white()
	collision.disabled = false
	await get_tree().create_timer(0.1).timeout
	attack_area.visible = false
	collision.disabled = true
	boss.switch_to(BossWaiting)
	is_movement = true

func _process_movement(delta: float) -> void:
	var next_position := nav_agent.get_next_path_position()
	boss.global_position = boss.global_position.move_toward(next_position, delta * movement_speed)
	next_position.y = boss.global_position.y
	boss.look_at(next_position)
