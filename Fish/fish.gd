extends Area2D

@onready var hooked_timer: Timer = $HookedTimer
@onready var hit_box: Area2D = $HitBox

signal caught(fish)
signal hooked(fish)
signal obstacle_hit(fish)

var shake = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !hooked_timer.is_stopped():
		shake *= -1
		position.x += 5 * shake

func _on_hooked_timer_timeout() -> void:
	hooked.emit(self)
	hit_box.monitoring = true

func _on_body_entered(body: Node2D) -> void:
	caught.emit(self)

func _on_hook_box_hook_box_entered() -> void:
	hooked_timer.wait_time = randi_range(2, 4)
	hooked_timer.start()
	# TODO: Play hooking animation

func _on_hook_box_hook_box_exited() -> void:
	# TODO: Stop the hooking animation
	hooked_timer.stop()

func _on_hit_box_hit_box_entered() -> void:
	obstacle_hit.emit(self)
