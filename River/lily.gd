extends Sprite2D


var original_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	original_position = position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	position.y = original_position.y + sin(Time.get_unix_time_from_system()) * 5
