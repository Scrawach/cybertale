class_name Virus
extends Node3D

@export var movement_speed: float = 5.0
@export var attack_range: float = 1.25
@export var is_endless_chasing: bool = false

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var cooldown_timer: Timer = $"Cooldown Timer"

var target: Node3D

enum State {
	Idle,
	Walking,
	Chasing,
	Attack
}

var current_state: State

func _physics_process(delta: float) -> void:
	process_state(current_state, delta)

func process_state(state: State, delta: float) -> void:
	match current_state:
		State.Idle:
			pass
		State.Walking:
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
			pass
		State.Chasing:
			pass
		State.Attack:
			$"Attack Hurt Box/CollisionShape3D".disabled = false
			await get_tree().create_timer(0.1).timeout
			$"Attack Hurt Box/CollisionShape3D".disabled = true
			
			cooldown_timer.start()
			
			
			if target != null:
				switch_to(State.Chasing)
			else:
				switch_to(State.Idle)

func _process_chase(delta: float) -> void:
	set_target_position(target.global_position)
	var target_is_nearest: bool = global_position.distance_to(target.global_position) < attack_range
	
	if target_is_nearest and cooldown_timer.is_stopped():
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

func _on_observer_body_exited(body: Node3D) -> void:
	if not is_endless_chasing:
		target = null
		switch_to(State.Idle)
