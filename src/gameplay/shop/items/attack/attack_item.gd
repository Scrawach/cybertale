class_name AttackItem
extends ShopItemResource

@export var strength: int

var hero: Hero

func apply(target: Hero) -> void:
	hero = target
	hero.stats.upgrade_damage(strength)

func get_tooltip_text() -> String:
	return tr(tooltip) % strength
