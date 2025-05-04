class_name Shop
extends Node3D

@export var hero: Hero
@export var available_items: Array[ShopItemResource]

@export var roll_place: ShopItemPlace

func _ready() -> void:
	if hero != null:
		initialize(hero)

func initialize(hero: Hero) -> void:
	self.hero = hero
	hero.inventory.coins_changed.connect(_on_coins_changed)
	roll_place.purchased.connect(func(item): roll())
	roll()

func roll() -> void:
	for child in get_children():
		if child is ShopItemPlace and child.item.tooltip != "ROLL_ITEM_KEY":
			var random_item_index: int = randi_range(0, available_items.size() - 1)
			child.item = available_items[random_item_index]
			child.initialize()
			child.paint_price(hero.inventory.value)
		else:
			child.initialize()

func _on_coins_changed(coins: int) -> void:
	for child in get_children():
		if child is ShopItemPlace:
			child.paint_price(coins)
