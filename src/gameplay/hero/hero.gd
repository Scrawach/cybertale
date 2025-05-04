class_name Hero
extends CharacterBody3D

const GRAVITY: float = 9.81

@export var camera: CameraPoint

@onready var hitbox: Area3D = $Hitbox
@onready var dash_timer: Timer = $"Dash Timer"
@onready var health: Health = $Health
@onready var inventory: Inventory = $Inventory
@onready var stats: HeroStats = $HeroStats
@onready var effects: Array[ShopItemResource]

@onready var attack_cooldown: Timer = $"Attack Cooldown"

@onready var body_animation: AnimationPlayer = $"hero-base/AnimationPlayer"
@onready var base_animation_scale: float = 1.2

@onready var slashes: Array[SlashVFX] = [
	$"Slashes/Slash VFX", $"Slashes/Slash VFX2", $"Slashes/Slash VFX3"
]

@export var hit_effect: PackedScene
@onready var hurt_collider: CollisionShape3D = %"Hurt Collision"

@onready var dash_vfx: Node3D = %"Dash VFX"

var previous_slash_index: int = 0
var is_dash: bool = false
var direction_angle: float
var is_attack_processing: bool

var is_can_control: bool = true

func _ready() -> void:	
	dash_timer.timeout.connect(_on_dash_timeout)
	health.damage_taken.connect(_on_damage_taken)

func _physics_process(delta: float) -> void:
	if not is_can_control:
		return
	
	body_animation.speed_scale = stats.movement_speed / 8 * base_animation_scale
	
	if not is_dash:
		if Input.is_action_just_pressed("attack") and attack_cooldown.is_stopped():
			_attack_process()
		
		if Input.is_action_just_pressed("alt_attack") and attack_cooldown.is_stopped():
			_alt_attack_process()
		
		if is_attack_processing:
			body_animation.play("Idle")
			return
	
		if Input.is_action_just_pressed("dash"):
			_start_dash()
	
	if not is_dash:
		_movement_process(delta)
	else:
		_dash_process(delta)
	
	_rotation_process(delta)
	_animation_process()

func _rotation_process(delta: float) -> void:
	if not Vector2(velocity.z, velocity.x).is_zero_approx():
		direction_angle = Vector2(velocity.z, velocity.x).angle()

	rotation.y = lerp_angle(rotation.y, direction_angle, delta * 10)

func _animation_process() -> void:
	if is_dash:
		body_animation.play("Dash")
		return
	
	if velocity.length_squared() > 0.2:
		body_animation.play("FastRun")
	else:
		body_animation.play("Idle")

func _movement_process(delta: float) -> void:
	var movement_input = get_movement_input(camera.camera)
	var movement = movement_input * stats.movement_speed
	movement.y -= GRAVITY
	velocity = movement
	move_and_slide()

func show_health_bar(is_active: bool) -> void:
	$"Health Bar".visible = is_active

func set_hud_active(is_active: bool) -> void:
	$CanvasLayer.visible = is_active

func set_input_active(is_active: bool) -> void:
	is_can_control = is_active

func hide_view() -> void:
	$"hero-base".hide()
	$Hitbox/CollisionShape3D.disabled = true

func show_view() -> void:
	$"hero-base".show()
	$Hitbox/CollisionShape3D.disabled = false

func on_step() -> void:
	Audio.play("res://gameplay/hero/sounds/step3.wav", Vector2(2, 2.2))

func _alt_attack_process() -> void:
	Audio.play("res://gameplay/hero/sounds/attack.wav", Vector2(1.5, 1.8))
	attack_cooldown.start()
	is_attack_processing = true
	hurt_collider.set_deferred("disabled", false)
	var slash = slashes[previous_slash_index]
	previous_slash_index += 1
	previous_slash_index %= slashes.size()
	slash.visible = true
	slash.play()
	await get_tree().create_timer(0.3).timeout
	hurt_collider.set_deferred("disabled", true)
	
	slash.visible = false
	is_attack_processing = false

func _attack_process() -> void:
	rotate_to_cursor()
	_alt_attack_process()

func rotate_to_cursor() -> void:
	var view_point: Vector3 = camera.get_mouse_position_in_world_3d()	
	var view_direction: Vector3 = (view_point - global_position)
	var angle = Vector2(view_direction.z, view_direction.x).angle()
	direction_angle = angle
	rotation.y = direction_angle

func _start_dash() -> void:
	camera.shake(0.05)
	camera.add_size(2)
	is_dash = true
	hitbox.monitoring = false
	dash_timer.start(stats.dash_length)
	dash_vfx.visible = true
	Audio.play("res://gameplay/hero/sounds/attack.wav", Vector2(1.9, 2.2))

func _end_dash() -> void:
	camera.reset_size()
	is_dash = false
	hitbox.monitoring = true
	dash_timer.stop()
	dash_vfx.visible = false

func _on_dash_timeout() -> void:
	_end_dash()

func _dash_process(_delta: float) -> void:
	var direction: Vector3 = Vector3.BACK.rotated(Vector3.UP, direction_angle).normalized()
	velocity = direction * stats.get_dash_speed() 
	move_and_slide()

func vector3_from_angle_z(z) -> Vector3:
	return Vector3(sin(z), 0, cos(z))

func get_movement_input(relative: Node3D) -> Vector3:
	var input := Vector3.ZERO
	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward", "move_backward")
	input = input.rotated(Vector3.UP, relative.global_rotation.y )
	return input.normalized()

func pickup(item) -> void:
	inventory.pickup(1)


func _on_hurt_box_area_entered(area: Area3D) -> void:
	var hit = hit_effect.instantiate()
	owner.add_child(hit)
	hit.position = area.global_position
	hit.position.y = hurt_collider.global_position.y
	health.heal(ceil(stats.vampire_strength * stats.damage))
	camera.shake(0.03)

func _on_damage_taken(value: int) -> void:
	Audio.play("res://gameplay/hero/sounds/hit.wav")
	camera.play_take_damage()
