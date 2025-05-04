extends GPUParticles3D

func _ready() -> void:
	emitting = true

func _on_lifetimer_timeout() -> void:
	queue_free()
