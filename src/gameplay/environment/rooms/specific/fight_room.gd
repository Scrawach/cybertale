class_name FightRoom
extends TrainingRoom

@export var doors: Array[NextRoomDoor]

@onready var progress_bar: ProgressBar = $CanvasLayer/MarginContainer/ProgressBar

func _ready() -> void:
	for custom_door in doors:
		custom_door.used.connect(_on_door_used)
	
	progress_bar.max_value = want_to_spawn
	progress_bar.value = want_to_spawn

func _on_spawn() -> void:
	create_tween().tween_property(progress_bar, "value", want_to_spawn - spawned, 0.5)

func _on_timeout() -> void:
	alive_enemies = get_enemies_count()
	
	if alive_enemies < 1 and want_to_spawn <= spawned:
		timer.stop()
		
		for custom_door in doors:
			custom_door.enable()

func _on_door_used(body: Hero, door: NextRoomDoor) -> void:
	completed.emit(door)
