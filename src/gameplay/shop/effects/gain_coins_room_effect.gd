class_name GainCoinsRoomEffect
extends RoomEffect

var strength: int = 10

func after_room() -> void:
	hero.inventory.pickup(strength)
