class_name HealAfterRoomItem
extends ShopItemResource

@export var strength: int

var hero: Hero

func apply(target: Hero) -> void:
	hero = target
	hero.effects.append(self)

func before_room() -> void:
	pass

func after_room() -> void:
	hero.health.heal(strength)

func get_tooltip_text() -> String:
	return tr(tooltip) % strength
