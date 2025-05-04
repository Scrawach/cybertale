class_name HeroDeath
extends Node

@export var hero: Hero
@export var gameplay: GameplayWorld

func _ready() -> void:
	hero.health.died.connect(_on_hero_died)

func _on_hero_died() -> void:
	if gameplay.is_active:
		gameplay.revive_hero()
	else:
		hero.health.restore()
	
