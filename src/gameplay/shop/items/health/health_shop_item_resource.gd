class_name HealthShopItemResource
extends ShopItemResource

@export var strength: int

func apply(target: Hero) -> void:
	target.health.heal(strength)

func get_tooltip_text() -> String:
	return tr(tooltip) % strength
