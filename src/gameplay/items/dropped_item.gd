class_name DroppedItem
extends RigidBody3D

@export var delay_before_pickup: float
@export var pickup_speed: float = 15.0

@onready var collision: CollisionShape3D = %CollisionShape3D

var target: Node3D

func _ready() -> void:
	await get_tree().create_timer(delay_before_pickup).timeout
	collision.set_deferred("disabled", false)

func _physics_process(delta: float) -> void:
	if target == null:
		return
	
	var direction = (target.global_position + Vector3.UP) - global_position
	global_position += direction.normalized() * pickup_speed * delta
	
	if direction.length_squared() < 0.1:
		if target.has_method("pickup"):
			target.pickup(self)
		queue_free()

func _on_pickup_area_body_entered(body: Node3D) -> void:
	target = body
	collision.set_deferred("disabled", true)
