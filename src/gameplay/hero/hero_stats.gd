class_name HeroStats
extends Node

@export var health: int
@export var movement_speed: float
@export var damage: int
@export var dash_length: float
@export var vampire_strength: float

@export var health_node: Health
@export var hero_node: Hero
@export var weapon_damage: Damage

func _ready() -> void:
	health_node.initialize(health)
	weapon_damage.value = damage

func get_dash_speed() -> float:
	return movement_speed * 3.0

func upgrade_health(value: int) -> void:
	health += value
	health_node.increase_max_value(value)

func upgrade_damage(value: int) -> void:
	damage += value
	weapon_damage.value = damage

func upgrade_movement_speed(value: float) -> void:
	movement_speed += value
