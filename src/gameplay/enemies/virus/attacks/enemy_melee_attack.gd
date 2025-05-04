class_name EnemyMeleeAttack
extends EnemyAttack

@export var body: Virus
@export var collision: CollisionShape3D
@export var vfx_point: Node3D
@export var attacK_vfx: PackedScene

@onready var cooldown: Timer = $"Cooldown Timer"
@onready var danger_zone: MeshInstance3D = $"../Danger Area"
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"

func can_attack() -> bool:
	return cooldown.is_stopped()

func start() -> void:
	
	danger_zone.scale = Vector3.ONE
	var tween = create_tween()
	tween.tween_property(danger_zone, "scale", 6 * Vector3.ONE, 0.6)
	danger_zone.show()
	
	animation_player.play("attack")
	animation_player.speed_scale = 1.0
	await get_tree().create_timer(0.8).timeout
	var vfx_instance = attacK_vfx.instantiate()
	body.get_parent().add_child(vfx_instance)
	vfx_instance.global_position = vfx_point.global_position
	collision.disabled = false
	Audio.play("res://gameplay/environment/sounds/door-open.wav", Vector2(1.3, 1.4), true)
	await get_tree().create_timer(0.1).timeout
	collision.disabled = true
	animation_player.play("idle")
	animation_player.speed_scale = 1.0
	await get_tree().create_timer(0.1).timeout
	cooldown.start()
	
	if body.target != null:
		body.switch_to(Virus.State.Chasing)
	else:
		body.switch_to(Virus.State.Idle)
	danger_zone.hide()

func stop() -> void:
	cooldown.start()
