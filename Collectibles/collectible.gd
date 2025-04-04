extends Area2D

var speed
var original_position: Vector2
var random_offset

signal caught(collectible)
signal hooked(collectible)
signal obstacle_hit(collectible)

var is_being_reeled: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	speed = randi_range(25, 35)
	original_position = Vector2(position.x,position.y)
	random_offset = randi_range(0, 99)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !is_being_reeled:
		position.x += speed * delta
		position.y = original_position.y + sin(Time.get_unix_time_from_system() + random_offset) * 6


func _on_despawn_timer_timeout() -> void:
	queue_free()


func _on_col_hook_box_2_area_entered(_area: Area2D) -> void:
	is_being_reeled = true
	hooked.emit(self)


func _on_col_hit_box_2_area_entered(_area: Area2D) -> void:
	obstacle_hit.emit(self)


func _on_body_entered(_body: Node2D) -> void:
	caught.emit(self)
