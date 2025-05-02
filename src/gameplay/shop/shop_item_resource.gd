class_name ShopItemResource
extends Resource

@export var view: PackedScene
@export var price: int
@export var tooltip: String

func apply(target: Hero) -> void:
	pass

func get_tooltip_text() -> String:
	return ""
