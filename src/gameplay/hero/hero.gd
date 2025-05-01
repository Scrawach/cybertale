class_name Hero
extends CharacterBody3D

@export var camera: CameraPoint
@export var movement_speed: float = 5.0
@export var dash_speed: float = 15.0

@onready var hitbox: Area3D = $Hitbox
@onready var dash_timer: Timer = $"Dash Timer"
@onready var health: Health = $Health

@onready var attack_cooldown: Timer = $"Attack Cooldown"

var is_dash: bool = false
var direction_angle: float
var is_attack_processing: bool

func _ready() -> void:
	dash_timer.timeout.connect(_on_dash_timeout)
	pass

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("dash") and not is_dash:
		_start_dash()
	
	if not is_dash:
		if Input.is_action_just_pressed("attack") and attack_cooldown.is_stopped():
			_attack_process()
			
		_movement_process(delta)
	else:
		_dash_process(delta)
	
	if not is_attack_processing:
		_rotation_process(delta)

func _rotation_process(delta: float) -> void:
	if not Vector2(velocity.z, velocity.x).is_zero_approx():
		direction_angle = Vector2(velocity.z, velocity.x).angle()

	rotation.y = lerp_angle(rotation.y, direction_angle, delta * 10)

func _movement_process(_delta: float) -> void:
	var movement_input = get_movement_input(camera.camera)
	velocity = movement_input * movement_speed
	move_and_slide()

func _attack_process() -> void:
	var view_point: Vector3 = camera.get_mouse_position_in_world_3d()
	var view_direction: Vector3 = -1 * (view_point - global_position)
	look_at(global_position + view_direction)
	direction_angle = rotation_degrees.y
	
	attack_cooldown.start()
	$HurtBox/MeshInstance3D.visible = true
	$HurtBox/CollisionShape3D.disabled = false
	is_attack_processing = true
	await get_tree().create_timer(0.2).timeout
	is_attack_processing = false
	$HurtBox/MeshInstance3D.visible = false
	$HurtBox/CollisionShape3D.disabled = true

func _start_dash() -> void:
	is_dash = true
	hitbox.monitoring = false
	dash_timer.start()

func _end_dash() -> void:
	is_dash = false
	hitbox.monitoring = true
	dash_timer.stop()

func _on_dash_timeout() -> void:
	_end_dash()

func _dash_process(_delta: float) -> void:
	var direction: Vector3 = Vector3.BACK.rotated(Vector3.UP, direction_angle).normalized()
	velocity = direction * dash_speed
	move_and_slide()

func vector3_from_angle_z(z) -> Vector3:
	return Vector3(sin(z), 0, cos(z))

func get_movement_input(relative: Node3D) -> Vector3:
	var input := Vector3.ZERO
	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward", "move_backward")
	input = input.rotated(Vector3.UP, relative.global_rotation.y )
	return input.normalized()


func _on_hitbox_area_entered(damage: Damage) -> void:
	if damage == null:
		return
	
	if damage:
		health.take_damage(damage.value)
