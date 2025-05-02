class_name MovementItem
extends ShopItemResource

@export var strength: int

var hero: Hero

func apply(target: Hero) -> void:
	hero = target
	hero.stats.upgrade_movement_speed(strength)

func get_tooltip_text() -> String:
	return tr(tooltip)
