class_name BossWaiting
extends BossStage

@export var boss: Boss

@export var min_time: float
@export var max_time: float

@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.timeout.connect(_on_timeout)

func start() -> void:
	var wait_time = randf_range(min_time, max_time)
	timer.start(wait_time)

func process(delta: float) -> void:
	pass

func stop() -> void:
	pass

func _on_timeout() -> void:
	var index = randi_range(0, 1)
	var stages = [BossChasing, BossBombs]
	boss.switch_to(BossChasing)
