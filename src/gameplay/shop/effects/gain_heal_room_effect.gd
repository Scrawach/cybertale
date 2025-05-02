class_name GainHealRoomEffect
extends RoomEffect

var strength: int = 10

func after_room() -> void:
	hero.health.heal(strength)
