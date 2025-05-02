class_name CointPickupUI
extends Node3D

@export var inventory: Inventory

@onready var icon: TextureRect = %TextureRect
@onready var label: Label = %Label
@onready var animation: AnimationPlayer = $SubViewport/AnimationPlayer
@onready var timer: Timer = $Awaiting

var tween: Tween

func _ready() -> void:
	inventory.coins_changed.connect(_on_coins_changed)
	timer.timeout.connect(_on_timeout)
	_on_coins_changed(inventory.value)
	_on_timeout()

func _on_coins_changed(value: int) -> void:
	visible = true
	label.text = str(value)
	animation.play("pickup")
	timer.start()

func _on_timeout() -> void:
	visible = false
