class_name FloatingNumbers
extends Node3D

@export var negative_number_color: Color
@export var positive_number_color: Color
@export var height: float = 2.0

@onready var label: Label = $SubViewport/Control/Label

func setup(start_position: Vector3, value: int) -> void:
	label.text = str(value)
	
	if value < 0:
		label.text = "-%s" % value

	var tween = create_tween()
	global_position = start_position
	tween.tween_property(self, "global_position", start_position + Vector3.UP * height, 0.75).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUART)
	
	var parallel_tween = tween.parallel()
	parallel_tween.tween_property(label, "modulate:a", 0, 0.9)
	tween.tween_callback(func(): queue_free())
