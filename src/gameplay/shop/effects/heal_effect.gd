class_name HealEffect
extends RoomEffect

@export var strength: int

func attach_hero(target: Hero) -> void:
	hero = target
