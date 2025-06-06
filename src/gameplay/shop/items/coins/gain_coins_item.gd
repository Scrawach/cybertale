class_name GainCoinsItem
extends ShopItemResource

@export var strength: int

var hero: Hero

func apply(target: Hero) -> void:
	hero = target
	hero.effects.append(self)

func after_room() -> void:
	hero.inventory.pickup(strength)

func get_tooltip_text() -> String:
	return tr(tooltip) % strength
