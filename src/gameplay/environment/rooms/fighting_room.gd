class_name FightingRoom
extends Room

@export var want_to_spawn: int

@onready var enemies: Node3D = $"Enemies"
@onready var timer: Timer = $Timer

func _ready() -> void:
	super._ready()
	timer.timeout.connect(_on_timeout)

func _on_timeout() -> void:
	if enemies.get_child_count() < 1:
		timer.stop()
		open_doors()
