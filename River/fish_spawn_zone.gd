extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var fish_spawn_timer: Timer = $FishSpawnTimer
const FISH = preload("res://Fish/fish.tscn")

signal fish_hooked(fish)
signal fish_caught(fish)
signal fish_obstacle_hit(fish)

var current_fish

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fish_spawn_timer.start()

func _on_fish_spawn_timer_timeout() -> void:
	current_fish = FISH.instantiate()
	current_fish.hooked.connect(on_fish_hooked)
	current_fish.caught.connect(on_fish_caught)
	current_fish.obstacle_hit.connect(on_fish_obstacle_hit)
	current_fish.position = random_spawn_location()
	get_tree().root.add_child(current_fish)


func random_spawn_location() -> Vector2:
	var spawn_x_min = collision_shape_2d.global_position.x - collision_shape_2d.shape.get_rect().size.x/2
	var spawn_x_max = collision_shape_2d.global_position.x + collision_shape_2d.shape.get_rect().size.x/2
	var spawn_y_min = collision_shape_2d.global_position.y - collision_shape_2d.shape.get_rect().size.y/2
	var spawn_y_max = collision_shape_2d.global_position.y + collision_shape_2d.shape.get_rect().size.y/2
	var spawn_location = Vector2(randi_range(spawn_x_min, spawn_x_max), randi_range(spawn_y_min, spawn_y_max))
	return spawn_location

func on_fish_hooked(fish):
	fish_hooked.emit(fish)


func on_fish_caught(fish):
	fish_caught.emit(fish)
	

func on_fish_obstacle_hit(fish):
	fish_obstacle_hit.emit(fish)


func start_fish_spawn_timer():
	fish_spawn_timer.wait_time = 3
	fish_spawn_timer.start()

func set_current_fish_night_mode(is_enabled: bool):
	if current_fish != null:
		current_fish.set_night_mode(is_enabled)
