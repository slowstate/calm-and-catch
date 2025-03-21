extends Area2D

var speed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	speed = randi_range(55, 75)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x +=  speed * delta
