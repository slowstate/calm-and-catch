extends Area2D

var speed
var original_position: Vector2
var random_offset

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	speed = randi_range(55, 75)
	original_position = Vector2(position.x,position.y)
	random_offset = randi_range(0, 99)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x +=  speed * delta
	position.y = original_position.y + sin(Time.get_unix_time_from_system() + random_offset) * 6

func _on_despawn_timer_timeout() -> void:
	queue_free()
