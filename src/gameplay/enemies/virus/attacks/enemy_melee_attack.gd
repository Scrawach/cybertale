class_name EnemyMeleeAttack
extends EnemyAttack

@export var body: Virus
@export var collision: CollisionShape3D

@onready var cooldown: Timer = $"Cooldown Timer"

func can_attack() -> bool:
	return cooldown.is_stopped()

func start() -> void:
	collision.disabled = false
	await get_tree().create_timer(0.1).timeout
	collision.disabled = true
	
	cooldown.start()
	
	if body.target != null:
		body.switch_to(Virus.State.Chasing)
	else:
		body.switch_to(Virus.State.Idle)

func stop() -> void:
	pass
