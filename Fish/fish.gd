extends Area2D

@onready var hitbox: CollisionShape2D = $Hitbox
@onready var hooked_timer: Timer = $HookedTimer

signal caught(fish)
signal hooked(fish)

var shake = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !hooked_timer.is_stopped():
		shake *= -1
		position.x += 5 * shake

func _on_area_entered(area: Area2D) -> void:
	if area.collision_layer == 2:
		hooked_timer.wait_time = randi_range(2, 4)
		hooked_timer.start()
	elif area.collision_layer == 3:
		# Add interaction with obstacles
		print("collision layer 3: obstacle")

func _on_hooked_timer_timeout() -> void:
	if has_overlapping_areas():
		hooked.emit(self)

func _on_body_entered(body: Node2D) -> void:
	caught.emit(self)
