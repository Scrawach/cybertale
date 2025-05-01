class_name HitBox
extends Area3D

@export var health: Health

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(damage: Damage) -> void:
	if damage == null:
		return
	
	health.take_damage(damage.value)
