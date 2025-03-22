extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var boat_spawn_timer: Timer = $BoatSpawnTimer
const BOAT = preload("res://Boat/boat.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	boat_spawn_timer.wait_time = randf_range(5,15)
	boat_spawn_timer.start()

func _on_obstacle_spawn_timer_timeout() -> void:
	var new_obstacle = BOAT.instantiate()
	new_obstacle.position = random_spawn_location()
	get_tree().root.add_child(new_obstacle)
	boat_spawn_timer.wait_time = randi_range(90, 120)
	boat_spawn_timer.start()

func random_spawn_location() -> Vector2:
	var spawn_x_min = position.x - collision_shape_2d.shape.get_rect().size.x/2
	var spawn_x_max = position.x + collision_shape_2d.shape.get_rect().size.x/2
	var spawn_y_min = position.y - collision_shape_2d.shape.get_rect().size.y/2
	var spawn_y_max = position.y + collision_shape_2d.shape.get_rect().size.y/2
	var spawn_location = Vector2(randi_range(spawn_x_min, spawn_x_max), randi_range(spawn_y_min, spawn_y_max))
	return spawn_location
	
