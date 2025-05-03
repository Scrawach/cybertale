class_name SmartProgressBar
extends ProgressBar

@export var room_icon: PackedScene

var room_icons: Array[RoomIcon]

func setup_path(count_of_rooms: int) -> void:
	var offset: int = size.x / (count_of_rooms + 1)
	var acc = offset
	
	for i in count_of_rooms:
		var instance: RoomIcon = room_icon.instantiate() as RoomIcon
		add_child(instance)
		instance.position.x = acc
		acc += offset
		
		if value > (i + 1):
			instance.mark_as_reach()
		
		room_icons.append(instance)

func complete_room(room_number: int) -> void:
	const VISUAL_OFFSET: float = 0.1
	value = room_number + VISUAL_OFFSET
	for i in room_number:
		if room_icons.size() <= i:
			break
		
		var icon = room_icons[i]
		icon.mark_as_reach()
		
