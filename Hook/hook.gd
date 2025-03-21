extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var original_position: Vector2
var random_offset = 0
var is_bobbing = false

func _process(delta: float) -> void:
	if is_bobbing:
		position.y = original_position.y + sin(Time.get_unix_time_from_system()) * 4

func enable_collision(enable: bool):
	collision_shape_2d.disabled = !enable

func set_bobbing(bobbing: bool):
	if !is_bobbing: original_position = position
	is_bobbing = bobbing
