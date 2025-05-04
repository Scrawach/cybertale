class_name EnemyRangeAttack
extends EnemyAttack

@export var body: Virus
@export var projectile_template: PackedScene
@export var fire_point: Marker3D

@onready var cooldown: Timer = $"Cooldown Timer"

var is_processing: bool

func can_attack() -> bool:
	return cooldown.is_stopped() and not is_processing

func start() -> void:
	is_processing = true
	var target = body.target
	var direction = target.global_position - body.global_position
	direction.y = 0
	body.look_at(body.global_position + direction)
	
	for i in range(3):
		var projectile: EnemyProjectile = projectile_template.instantiate()
		body.get_parent().add_child(projectile)
		projectile.global_transform = fire_point.global_transform
		projectile.launch(direction)
		await get_tree().create_timer(0.2).timeout
	
	cooldown.start()
	is_processing = false
	
	if body.target != null:
		body.switch_to(Virus.State.Chasing)
	else:
		body.switch_to(Virus.State.Idle)

func stop() -> void:
	pass
