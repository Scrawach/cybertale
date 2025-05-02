class_name ShopItemPlace
extends Node3D

@export var item: ShopItemResource

@onready var item_view: Node3D = $Item
@onready var collision: CollisionShape3D = %CollisionShape3D

var target: Hero

func _ready() -> void:
	initialize()

func initialize() -> void:
	var view: Node3D = item.view.instantiate()
	item_view.add_child(view)

func _input(event: InputEvent) -> void:
	if target != null and event.is_action_pressed("interact"):
		interact()

func interact() -> void:
	if try_purchase():
		item_view.visible = false
		print(item_view.visible)
	else:
		print("not enouth coins!")

func try_purchase() -> bool:
	if target.inventory.value < item.price:
		return false
	
	target.inventory.substract(item.price)
	item.apply(target)
	collision.disabled = true
	return true

func _on_area_3d_body_entered(body: Hero) -> void:
	target = body

func _on_area_3d_body_exited(body: Hero) -> void:
	if body != target:
		return
	
	target = null
