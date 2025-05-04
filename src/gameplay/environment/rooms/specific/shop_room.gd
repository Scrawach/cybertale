class_name ShopRoom
extends ScenarioRoom

@export var hero: Hero
@onready var shop: Shop = $Shop

func _ready() -> void:
	if hero != null:
		initialize(hero)
	
	door.used.connect(func(body: Hero, _door: NextRoomDoor): completed.emit(_door))

func initialize(hero: Hero) -> void:
	shop.initialize(hero)
