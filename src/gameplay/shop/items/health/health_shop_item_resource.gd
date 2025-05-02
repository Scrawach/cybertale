class_name HealthShopItemResource
extends ShopItemResource

@export var strength: int

func apply(target: Hero) -> void:
	target.health.heal(strength)
