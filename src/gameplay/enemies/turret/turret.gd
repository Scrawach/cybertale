class_name Turret
extends Node3D

@export var angle_speed: float = 1
@onready var gun: Node3D = $Gun
@onready var fire_area: Area3D = %"Fire Hurt Box"
@onready var cooldown_timer: Timer = $"Cooldown Timer"

var target: Node3D
var desired_angle: float
var is_firing: bool

func _on_observer_body_entered(body: Node3D) -> void:
	target = body

func _on_observer_body_exited(body: Node3D) -> void:
	target = null


func _physics_process(_delta: float) -> void:
	if target == null:
		return
	
	if is_firing:
		return
	
	var direction_to_target = target.global_position - global_position
	direction_to_target.y = 0
	direction_to_target = direction_to_target.normalized()
	
	if not Vector2(direction_to_target.z, direction_to_target.x).is_zero_approx():
		desired_angle = Vector2(direction_to_target.z, direction_to_target.x).angle()
		
	var angle_step: float = desired_angle - gun.rotation.y
	gun.rotation.y += angle_step 
	
	if angle_step < 5 and cooldown_timer.is_stopped():
		cooldown_timer.start()
		fire()

func fire() -> void:
	is_firing = true
	$"Gun/Fire Point/Fire Hurt Box/CollisionShape3D".disabled = false
	$"Gun/Fire Point/Fire Hurt Box/MeshInstance3D".visible = true
	await get_tree().create_timer(0.1).timeout
	$"Gun/Fire Point/Fire Hurt Box/CollisionShape3D".disabled = true
	$"Gun/Fire Point/Fire Hurt Box/MeshInstance3D".visible = false
	is_firing = false
