class_name Shop
extends Node3D

@export var hero: Hero

func _ready() -> void:
	initialize(hero)

func initialize(hero: Hero) -> void:
	hero.inventory.coins_changed.connect(_on_coins_changed)
	for child in get_children():
		if child is ShopItemPlace:
			child.initialize()
			child.paint_price(hero.inventory.value)

func _on_coins_changed(coins: int) -> void:
	for child in get_children():
		if child is ShopItemPlace:
			child.paint_price(coins)
