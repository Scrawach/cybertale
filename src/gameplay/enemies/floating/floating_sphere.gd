class_name FloatingSphere
extends Node3D

@export var movement_speed: float

@onready var model_player: AnimationPlayer = $View/floating_sphere/AnimationPlayer

@onready var idle_player: AnimationPlayer = $AnimationPlayer
@onready var agent: NavigationAgent3D = $NavigationAgent3D

func _ready() -> void:
	model_player.seek(randf_range(0.0, 1.0))
	idle_player.seek(randf_range(0.0, 1.0))
	set_target_position(_random_point())

func _physics_process(delta: float) -> void:
	if agent.is_target_reached():
		set_target_position(_random_point())
	_process_movement(delta)

func _random_point() -> Vector3:
	return NavigationServer3D.map_get_random_point(agent.get_navigation_map(), 1, false)

func set_target_position(target_position: Vector3) -> void:
	agent.set_target_position(target_position)

func _process_movement(delta: float) -> void:
	var next_position := agent.get_next_path_position()
	var direction := next_position - global_position
	direction.y = 0
	
	global_position += direction.normalized() * movement_speed * delta
