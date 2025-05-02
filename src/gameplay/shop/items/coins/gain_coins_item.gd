class_name GainMaxHealthItem
extends ShopItemResource

@export var strength: int

var hero: Hero

func apply(target: Hero) -> void:
	hero = target
	pass

func before_room() -> void:
	pass

func after_room() -> void:
	pass

func get_tooltip_text() -> String:
	return tr(tooltip) % strength
