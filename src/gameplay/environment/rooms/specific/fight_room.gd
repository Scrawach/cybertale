class_name FightRoom
extends TrainingRoom

@export var doors: Array[NextRoomDoor]

func _on_timeout() -> void:
	if enemies.get_child_count() < 1 and want_to_spawn <= spawned:
		timer.stop()
		
		for custom_door in doors:
			custom_door.enable()
