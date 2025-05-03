class_name GameplayWorld
extends Node3D

@export var number_of_rooms: int = 5

@onready var progress: SmartProgressBar = $"Game Progress/MarginContainer/ProgressBar"

func start(hero: Hero) -> void:
	progress.show()
	await get_tree().create_timer(0.1).timeout # yep
	
	progress.setup_path(number_of_rooms)
	for i in (number_of_rooms + 1):
		await get_tree().create_timer(1.0).timeout
		progress.complete_room(i + 1)
