class_name Inventory
extends Node

signal coins_changed(value: int)

@export var value: int = 0

func pickup(coin_count: int) -> void:
	value += coin_count
	coins_changed.emit(value)

func substract(coins: int) -> void:
	value -= coins
	coins_changed.emit(value)
