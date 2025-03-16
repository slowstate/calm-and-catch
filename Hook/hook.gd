extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func enable_collision(enable: bool):
	collision_shape_2d.disabled = !enable
