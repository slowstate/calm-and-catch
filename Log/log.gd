extends Area2D

@onready var log_animation: Node2D = $LogAnimation

var speed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	log_animation.play_animation("Log_Move")
	speed = randi_range(55, 75)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x +=  speed * delta
