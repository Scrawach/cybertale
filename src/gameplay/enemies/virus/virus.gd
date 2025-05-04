class_name Virus
extends Node3D

@export var movement_speed: float = 5.0
@export var attack_range: float = 1.25
@export var is_endless_chasing: bool = false
@export var enemy_attack: EnemyAttack
@export var is_wandering: bool

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D

var target: Node3D

enum State {
	Idle,
	Walking,
	Chasing,
	Attack
}

var current_state: State

func _ready() -> void:
	if is_wandering:
		switch_to(State.Walking)

func _physics_process(delta: float) -> void:
	process_state(current_state, delta)

func process_state(state: State, delta: float) -> void:
	match state:
		State.Idle:
			pass
		State.Walking:
			_process_walking(delta)
			pass
		State.Chasing:
			_process_chase(delta)
			pass
		State.Attack:
			pass

func switch_to(state: State) -> void:
	current_state = state
	match current_state:
		State.Idle:
			pass
		State.Walking:
			set_target_position(_random_point())
		State.Chasing:
			pass
		State.Attack:
			await enemy_attack.start()

func _process_walking(delta: float) -> void:
	if nav_agent.is_target_reached():
		set_target_position(_random_point())
	
	_process_movement(delta)


func _random_point() -> Vector3:
	return NavigationServer3D.map_get_random_point(nav_agent.get_navigation_map(), 1, false)

func _process_chase(delta: float) -> void:
	set_target_position(target.global_position)
	var target_is_nearest: bool = global_position.distance_to(target.global_position) < attack_range
	
	if target_is_nearest and enemy_attack.can_attack():
		switch_to(State.Attack)
	elif not target_is_nearest:
		_process_movement(delta)

func set_target_position(target_position: Vector3) -> void:
	nav_agent.set_target_position(target_position)

func _process_movement(delta: float) -> void:
	var next_position := nav_agent.get_next_path_position()
	global_position = global_position.move_toward(next_position, delta * movement_speed)
	next_position.y = 0
	look_at(next_position)
	

func _on_observer_body_entered(body: Node3D) -> void:
	target = body
	switch_to(State.Chasing)

func _on_observer_body_exited(_body: Node3D) -> void:
	if not is_endless_chasing:
		target = null
		
		if is_wandering:
			switch_to(State.Walking)
		else:
			switch_to(State.Idle)
