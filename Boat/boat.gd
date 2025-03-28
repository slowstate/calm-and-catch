extends Area2D

@onready var stop_timer: Timer = $StopTimer
@onready var move_timer: Timer = $MoveTimer
@onready var despawn_timer: Timer = $DespawnTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var speed
var original_position: Vector2
var random_offset

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	original_position = Vector2(position.x,position.y)
	speed = 30
	animation_player.play("Boat_Move")
	move_timer.wait_time = randi_range(15,40)
	move_timer.start()
	stop_timer.wait_time = randi_range(10,30)
	random_offset = randi_range(0, 99)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x -=  speed * delta
	position.y = original_position.y + sin(Time.get_unix_time_from_system() + random_offset) * 6

func _on_move_timer_timeout() -> void:
	speed = 0
	animation_player.stop()
	stop_timer.start()

func _on_stop_timer_timeout() -> void:
	animation_player.play("Boat_Move")
	speed = 30

func _on_despawn_timer_timeout() -> void:
	queue_free()
