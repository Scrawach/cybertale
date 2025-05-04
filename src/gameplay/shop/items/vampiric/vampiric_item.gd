class_name VampiricItem
extends ShopItemResource

@export var strength: float

var hero: Hero

func apply(target: Hero) -> void:
	hero = target
	hero.stats.vampire_strength += strength

func get_tooltip_text() -> String:
	return tr(tooltip) % (strength * 100)
