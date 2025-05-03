class_name ShopRoom
extends Node3D

@export var hero: Hero
@onready var shop: Shop = $Shop

func _ready() -> void:
	shop.initialize(hero)
