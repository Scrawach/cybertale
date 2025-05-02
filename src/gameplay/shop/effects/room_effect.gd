class_name RoomEffect
extends RefCounted

var hero: Hero

func attach_hero(target: Hero) -> void:
	hero = target

func before_room() -> void:
	pass

func after_room() -> void:
	pass
