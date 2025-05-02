class_name ShopItemPlace
extends Node3D

@export var item: ShopItemResource

@onready var item_view: Node3D = $Item
@onready var collision: CollisionShape3D = %CollisionShape3D
@onready var tooltip: WorldSpaceTooltip = $Item/WorldSpaceTooltip
@onready var price_tooltip: WorldSpaceTooltip = $"Item/Price Tooltip"
@onready var buy_tooltip: WorldSpaceTooltip = $"Item/Buy Tooltip"

var target: Hero

func _ready() -> void:
	initialize()

func initialize() -> void:
	var view: Node3D = item.view.instantiate()
	item_view.add_child(view)
	setup_tooltips()

func setup_tooltips() -> void:
	tooltip.setup(item.get_tooltip_text())
	price_tooltip.setup(str(item.price))
	buy_tooltip.setup(tr("BUY_INTERACT_KEY"))

func _input(event: InputEvent) -> void:
	if target != null and event.is_action_pressed("interact"):
		interact()

func interact() -> void:
	if try_purchase():
		item_view.visible = false
	else:
		print("not enouth coins!")

func try_purchase() -> bool:
	if target.inventory.value < item.price:
		return false
	
	target.inventory.substract(item.price)
	item.apply(target)
	collision.disabled = true
	return true

func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSLATION_CHANGED and buy_tooltip != null:
		setup_tooltips()

func _on_area_3d_body_entered(body: Hero) -> void:
	target = body
	tooltip.visible = true
	
	if body.inventory.has_enough_coins(item.price):
		buy_tooltip.visible = true

func _on_area_3d_body_exited(body: Hero) -> void:
	if body != target:
		return
		
	buy_tooltip.visible = false
	tooltip.visible = false
	target = null
