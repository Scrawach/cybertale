class_name HeroDeath
extends Node

@export var hero: Hero
@export var gameplay: GameplayWorld
@export var hero_dead: PackedScene

func _ready() -> void:
	hero.health.died.connect(_on_hero_died)

func _on_hero_died() -> void:
	hero.set_input_active(false)
	hero.hide_view()
	
	var instance = hero_dead.instantiate()
	hero.get_parent().add_child(instance)
	instance.global_transform = hero.global_transform
	
	await get_tree().create_timer(2.5).timeout
	
	if gameplay.is_active:
		gameplay.revive_hero()
	else:
		hero.health.restore()
	
	hero.show_view()
	hero.set_input_active(true)
	
