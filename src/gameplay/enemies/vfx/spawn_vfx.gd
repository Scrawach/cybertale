class_name SpawnVFX
extends Node3D

@export var play_on_ready: bool
@export var lifetime: float
@export var particles: Array[GPUParticles3D]

@onready var timer: Timer = $Timer

func _ready() -> void:
	if play_on_ready:
		for particle in particles:
			particle.emitting = true
	
	timer.start(lifetime)
	timer.timeout.connect(_on_timeout)

func _on_timeout() -> void:
	queue_free()
