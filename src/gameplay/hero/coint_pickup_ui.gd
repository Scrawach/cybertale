class_name CointPickupUI
extends Node3D

@export var inventory: Inventory

@onready var icon: TextureRect = %TextureRect
@onready var label: Label = %Label
@onready var animation: AnimationPlayer = $SubViewport/AnimationPlayer

var tween: Tween

func _ready() -> void:
	inventory.coins_changed.connect(_on_coins_changed)
	_on_coins_changed(inventory.value)

func _on_coins_changed(value: int) -> void:
	label.text = str(value)
	animation.play("pickup")
