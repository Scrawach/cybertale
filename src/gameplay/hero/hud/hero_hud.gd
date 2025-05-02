class_name HeroHUD
extends Control

@export var inventory: Inventory

@onready var coins: Label = $MarginContainer/HBoxContainer/Label

func _ready() -> void:
	inventory.coins_changed.connect(_on_coins_changed)
	_on_coins_changed(inventory.value)

func _on_coins_changed(value: int) -> void:
	coins.text = str(value)
