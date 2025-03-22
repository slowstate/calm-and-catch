extends Node2D

@onready var target: Node2D = $Node2D/Target
@onready var rod_tip: Sprite2D = $"Body/1/RodTip"

func get_rod_tip_global_position() -> Vector2:
	return rod_tip.global_position

func set_target(target_position: Vector2):
	target.global_position = target_position

func reset_target():
	target.position = Vector2(9, -436)
