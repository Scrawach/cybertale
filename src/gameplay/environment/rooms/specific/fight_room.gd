class_name FightRoom
extends TrainingRoom

@export var doors: Array[NextRoomDoor]

func _ready() -> void:
	for custom_door in doors:
		custom_door.used.connect(_on_door_used)

func _on_timeout() -> void:
	alive_enemies = get_enemies_count()
	
	if alive_enemies < 1 and want_to_spawn <= spawned:
		timer.stop()
		
		for custom_door in doors:
			custom_door.enable()

func _on_door_used(body: Hero, door: NextRoomDoor) -> void:
	completed.emit(door)
